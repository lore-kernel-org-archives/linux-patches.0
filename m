Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90D72223;
	Mon, 29 Jan 2024 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548508; cv=none; b=bGVq02d7ALTjV3piXDoTvdADtK9VkOyTvziAqw3pEYwGNfZ90fYlQ4+fwYTPprrCR400mQ/vgDga466gRnN1I+SClNoURaqMb3dqMS4nOCymmYom6ugVsCH5ny6UD6soCYmrvxpnyQAMZs7u2W7GN2VLQY0eIkmohG+3ziLsW7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548508; c=relaxed/simple;
	bh=DDlwDc+xM2X8vQgWiBTK5HMTxwxCJfNU+D7E7WianR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLEp/U6LguJzSxgj48TjfEuIwFBr/KJ/HT/3fc2IW4EJHhuYU2TnQyI54oRGRpHG+nF/9P0o6Q289uoPC5SdI+GUsMftsSWWZslkaLkAl7k98cn9jkDv50i/epDy+ulv7477vu9XLBY4kUw+qed2C5h52xYY/V0p6E8CvIeoaQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn2qkv6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn2qkv6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA890C433C7;
	Mon, 29 Jan 2024 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548508;
	bh=DDlwDc+xM2X8vQgWiBTK5HMTxwxCJfNU+D7E7WianR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn2qkv6fpJGn79P/F2QjSquzX6ntDmFDGIvbGxNFwMiJ7UhrwaWLgGCz3o/1usdEH
	 QQTgeZJ5LYhSFmfV1fkN7X0mu4jJsNMNXm7R9xT/FKjgYf4WBfu6QuvxQNBg/m5nU3
	 lKjdV+cj/lpdlgeJ3Nly6l/QTPViBdvtMD7zuPaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 113/331] arm64/sme: Always exit sme_alloc() early with existing storage
Date: Mon, 29 Jan 2024 09:02:57 -0800
Message-ID: <20240129170018.229687608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit dc7eb8755797ed41a0d1b5c0c39df3c8f401b3d9 upstream.

When sme_alloc() is called with existing storage and we are not flushing we
will always allocate new storage, both leaking the existing storage and
corrupting the state. Fix this by separating the checks for flushing and
for existing storage as we do for SVE.

Callers that reallocate (eg, due to changing the vector length) should
call sme_free() themselves.

Fixes: 5d0a8d2fba50 ("arm64/ptrace: Ensure that SME is set up for target when writing SSVE state")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240115-arm64-sme-flush-v1-1-7472bd3459b7@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1280,8 +1280,10 @@ void fpsimd_release_task(struct task_str
  */
 void sme_alloc(struct task_struct *task, bool flush)
 {
-	if (task->thread.sme_state && flush) {
-		memset(task->thread.sme_state, 0, sme_state_size(task));
+	if (task->thread.sme_state) {
+		if (flush)
+			memset(task->thread.sme_state, 0,
+			       sme_state_size(task));
 		return;
 	}
 


