Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294082BFC85;
	Mon, 17 Aug 2026 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975440; cv=none; b=a9S3WjV4LLcMean2VtxlY99GIUYfXc41CddLogR+pB9lNvu/Myk32KPX0mJBb3rC5+RduXXenvhwDwhOj9b8SX+chfI79iu+ColbTJcP1YWJnNTMGHe6JavjUfOuoaiB6E6uEV3Th0hf2QLmRlTDOr9RIquaE5vz+wfE3orwxxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975440; c=relaxed/simple;
	bh=k9fP+DsGrPIoBRiAeowGkXWpe6mgkOshs41o0Lfc75Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL3rGPPVbi80s6k0wiSxrxFtj2gCrykTJwmAcYTnuQ9sQUmXcSEkG7egcSKINaxrXJh7n0vtAaCKpk1Kl2ed3OCrGpgfyUdNbpNBR/NfSStEBhK0Ur4bu0Mxrx6MYBp3+Ay/yn0nZLf4hA3VEfIZYx9Z6G2nufgk4OGaozArprY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVN8fYuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVN8fYuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6821F00A3A;
	Mon, 17 Aug 2026 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975438;
	bh=UmOIvJ+9Q7nMwJ/kL5tRHM2s79iLOlQYhSkvNVq7Sto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVN8fYufNBysBLyGURTx5Kn7P8t1AWCh4eHVx6i8x5Cvhvg18E6Tk219mMIdewYvP
	 nKbiW+8rmEz75xHMDKN5qLZ+zn6oyBIkIk5NJ5FefRYbERy23UvzjIws/1rN/3pj5r
	 APIwu/xpv+wL4WL7Z4OeWgyIHpdxzOH786oFOhZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/389] Input: ims-pcu - fix logic error in packet reset
Date: Mon, 17 Aug 2026 15:27:28 +0200
Message-ID: <20260817132539.203156249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2c9b85a14abb4811e8d4773ccd13559e59792efb ]

ims_pcu_reset_packet() incorrectly sets have_stx to true, which implies
that the start-of-packet delimiter has already been received. This
causes the protocol parser to skip waiting for the next STX byte and
potentially process garbage data.

Correctly set have_stx to false when resetting the packet state.

Fixes: 875115b82c29 ("Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 71d96e7d842dab..0214c3bb2b096d 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -450,7 +450,7 @@ static void ims_pcu_handle_response(struct ims_pcu *pcu)
 
 static void ims_pcu_reset_packet(struct ims_pcu *pcu)
 {
-	pcu->have_stx = true;
+	pcu->have_stx = false;
 	pcu->have_dle = false;
 	pcu->read_pos = 0;
 	pcu->check_sum = 0;
-- 
2.53.0



