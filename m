Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C3113B2B3;
	Tue, 27 Feb 2024 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042876; cv=none; b=mrjBjuJGB6L5UtUB/VDs3a9juvKQ2+IvhSlS3IUCwKc9K3TV8GsDd7UbK3bvPDmFdPA0KUEciovEl4thVvMVKC/dHZa36XfcYcn3OI/oYqdRm/ymqIfCiTcCfDLT+VGX+WXJaZQnwXNQBdrtAUshbCSUdrpIX9tEWs+dEFBHb1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042876; c=relaxed/simple;
	bh=L8XruvLyz0eF9cBJCaTPyF9rIOkFD4zd2pHD86+/1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lshYTklfq/uja8VFFwfNuKvtmkEnQwQmCtRCMpYsol1kMKhEVXSBBCwdlZpOH4GAjcIlKUe9oiFsgzUrLzB+kX7k6GI3uVZRZumjbxsdqi2G8setL9bj0HVlWpoUVD3gKU7+Q5WUgBCM83AD86+QI+jp0RJfLp0EuG5FMMCsuj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaVRhrP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaVRhrP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6959C433C7;
	Tue, 27 Feb 2024 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042876;
	bh=L8XruvLyz0eF9cBJCaTPyF9rIOkFD4zd2pHD86+/1jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaVRhrP3UjWibdF/+ld/nmTjci8/joUDqJPK3op7D7A/N00kvo9gfctT7SOGjrnNG
	 Y2oPsbH/ApMoAmA9FFch6HQyGZSVbtJ5KyE05mmNtn57wptqisD9gD34VrlvPDfxeG
	 OoT9BLKuxx1ieQemIMFdNoPniugZN350ZedK0Kho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/245] powerpc/pseries/lpar: add missing RTAS retry status handling
Date: Tue, 27 Feb 2024 14:25:13 +0100
Message-ID: <20240227131619.288479890@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit daa8ab59044610aa8ef2ee45a6c157b5e11635e9 ]

The ibm,get-system-parameter RTAS function may return -2 or 990x,
which indicate that the caller should try again.

pseries_lpar_read_hblkrm_characteristics() ignores this, making it
possible to incorrectly detect TLB block invalidation characteristics
at boot.

Move the RTAS call into a coventional rtas_busy_delay()-based loop.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 1211ee61b4a8 ("powerpc/pseries: Read TLB Block Invalidate Characteristics")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-3-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lpar.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index fce0237b07155..6c196b9413553 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1434,22 +1434,22 @@ static inline void __init check_lp_set_hblkrm(unsigned int lp,
 
 void __init pseries_lpar_read_hblkrm_characteristics(void)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	unsigned char local_buffer[SPLPAR_TLB_BIC_MAXLENGTH];
 	int call_status, len, idx, bpsize;
 
 	if (!firmware_has_feature(FW_FEATURE_BLOCK_REMOVE))
 		return;
 
-	spin_lock(&rtas_data_buf_lock);
-	memset(rtas_data_buf, 0, RTAS_DATA_BUF_SIZE);
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				SPLPAR_TLB_BIC_TOKEN,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
-	memcpy(local_buffer, rtas_data_buf, SPLPAR_TLB_BIC_MAXLENGTH);
-	local_buffer[SPLPAR_TLB_BIC_MAXLENGTH - 1] = '\0';
-	spin_unlock(&rtas_data_buf_lock);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		memset(rtas_data_buf, 0, RTAS_DATA_BUF_SIZE);
+		call_status = rtas_call(token, 3, 1, NULL, SPLPAR_TLB_BIC_TOKEN,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		memcpy(local_buffer, rtas_data_buf, SPLPAR_TLB_BIC_MAXLENGTH);
+		local_buffer[SPLPAR_TLB_BIC_MAXLENGTH - 1] = '\0';
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		pr_warn("%s %s Error calling get-system-parameter (0x%x)\n",
-- 
2.43.0



