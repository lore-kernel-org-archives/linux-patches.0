Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66F3B52EE;
	Thu, 30 Jul 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427034; cv=none; b=VQjFYOkW/ijbR/+1Wq0CKRbMGcjW9mEjORyC7yWxMjxg0cR6S/gFq+C+BlPFfbB2xBhis7+eOu+bsSpFg/tZiwamT8kye3SuEJMGM7DFsVnaBqx3rSd/ZD3HmqvPZE+0q6Q3xNf2rBMnpKGQrb3fQz4mHVbnKCcicx/UX8OLqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427034; c=relaxed/simple;
	bh=tdBknpzwHS2ixfoE/iPPBK+xc08SvAfhy7ZNp+hV/T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ3N1CiAdo82GPG7+0tvhiqUGZq+zYZQ+5wEEnZFgbsF4qLpdstqn2i1L7FZ2PvvxGcMiXbNR46H5uAYujtaU++gucb5GPbFXC6ogIMjrMqm26fiCqfaUS0bEIWFRGQ7vZegQ934OnIa0ExZVZVoVGDyrOSU697/szE7avoA46U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKwepJ/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKwepJ/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D311F000E9;
	Thu, 30 Jul 2026 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427032;
	bh=0F5l+EzrRowsx0mrN1qYIDM5p4F+pU1IYjaeOAE4x2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKwepJ/qde0rJWzPPOliDPawIPK8n0zRv9WNdExednLXXCuqYrZsLTqgYAE08lfX9
	 E9oQvhdOvmHcNMG+PqcupTOaQC4N0HGYMHLfmqdkV7XFC+QvlHMKp4qlI0GeJluZGv
	 jHGmyBayXB3krzansdLGurZGlQ9gLGXMW1NXvZ4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/484] Input: ims-pcu - fix logic error in packet reset
Date: Thu, 30 Jul 2026 16:08:45 +0200
Message-ID: <20260730141424.035915238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af1dfc08b10b25..6b2aeaa50812f2 100644
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



