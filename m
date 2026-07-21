Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A094402444;
	Tue, 21 Jul 2026 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654472; cv=none; b=qFkofJo0b8Va1Si4AnvkkvLLQLZ4dHbURDLl1YMeBOOz1/ckR9mAjN9V3nN02UKvawAiFpSq0sX2tk6fexC3veAN3WrDwgn8gJi/ccHXengxuorWCPEj+yr3E0n4NYfWr9dTYoF9LGk3Qh0ldEsJW/foj45bvRT9T4F1hq43hOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654472; c=relaxed/simple;
	bh=FFW3XDlLBumEnX1+nP3kb2cw1yAUEAOKQq+gFrOsFpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vxg+GOoJ7cWvz53CQr01Vq0gYMw6tdTWxaPs/PXdXQs3/ZOIl1Y+LlpETb4XPdJoUmRW5VyWdojdj4YevwinNdoRLAFHVNfV3TshFyI6lwp8FEoSzqsX1A2SdFo0NrfJ5TPoWnScLOvev55Y8RrXqw2flM5FGm5f/NuoxLPbsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGripEoX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGripEoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720A81F000E9;
	Tue, 21 Jul 2026 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654471;
	bh=ZM/9IUOmxDaTQRpMfaq/Mr5/m0SEI5eyH6s5Y3sIoVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGripEoX0lntcGysRugsnIysa+qgbzN67YWMokS+AZjVt8fV+VveIwFRi9jdnVVb/
	 X5X69l+PZuFpr3fNoxzi0a/xzBCu5RNBe2dL5qBzDLaUTqzbgYYPzZLzdD7y4qTZ4/
	 D1EKELgJkXAvnUXCmsI7zwz5a+jSMQTXluizzDBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1718/2077] ntfs: fix hole runlist memory leak in insert range error path
Date: Tue, 21 Jul 2026 17:23:11 +0200
Message-ID: <20260721152633.276688051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 06769b8f23b4b645b270c438649fff79768fb6fe upstream.

ntfs_non_resident_attr_insert_range() allocates hole_rl before mapping the
whole runlist. If ntfs_attr_map_whole_runlist() fails, the error path drops
ni->runlist.lock and returns without freeing hole_rl. This leaks memory
of sizeof(*hole_rl) * 2 bytes.

Fix this memory leak by freeing hole_rl before returning from
that error path, matching the later error paths in the same function.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5327,6 +5327,7 @@ int ntfs_non_resident_attr_insert_range(
 	ret = ntfs_attr_map_whole_runlist(ni);
 	if (ret) {
 		up_write(&ni->runlist.lock);
+		kfree(hole_rl);
 		return ret;
 	}
 


