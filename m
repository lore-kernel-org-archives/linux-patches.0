Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786F346D08D;
	Tue, 21 Jul 2026 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654924; cv=none; b=EBe6jd/cQm56cyYiZTNikxQWvdR9aQ2Kq0uPUuHzhsYogO5S6wzKRwvZgRJJJsMMQO5KsYzGgevapyF/808vPRjw0tG7jVRvvRvV6AkDpYZcVIva1g4IPYD9GFtlpV79O3Lat0Mt9pX/qf1tWbam7vPiOhMDKfBLTAzI+Z1ljsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654924; c=relaxed/simple;
	bh=eIz5Rxl0rY5/eOdFTEAYYa7bkNBnfBwG6HLvXzWdV2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1Mmjlw+YU2kxk+Rpa6jV2XeYJT7O83rL30BVltNR+2qNX6B7hEJLl74XLfemHPstZpeg0HDFfWbaFbU2a2AWbtY866HBPs0E4iJ46p9e56jCWSQsL7Fi9wHabfEbvj6krtum14580AZ8tXMen3H/GWr3mNxjiuwJ/nINCQBTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB4zOqmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB4zOqmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E8A1F00A3D;
	Tue, 21 Jul 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654923;
	bh=RLS/epYayl6ty+qUi9KEqJRKB3iunQ9v3EtTmPELJzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vB4zOqmzFz3pNHONfm5Y8H9VAbZqvp4cXWhmWGH4N+7lp+DBBOAE9DUWQQ7QoGtqA
	 t0cj1YpEX9KLXvk0rzC4elhfxvB61q762Xtu5I4Y1QKLiEjDf3R+zF+R/rE83EQRoA
	 nS/dbXW7CBQLPpWZv+fWIaf/fLS1NZBkFtNSj3Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1887/2077] Input: ims-pcu - fix logic error in packet reset
Date: Tue, 21 Jul 2026 17:26:00 +0200
Message-ID: <20260721152637.227629302@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 2c9b85a14abb4811e8d4773ccd13559e59792efb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -450,7 +450,7 @@ static void ims_pcu_handle_response(stru
 
 static void ims_pcu_reset_packet(struct ims_pcu *pcu)
 {
-	pcu->have_stx = true;
+	pcu->have_stx = false;
 	pcu->have_dle = false;
 	pcu->read_pos = 0;
 	pcu->check_sum = 0;


