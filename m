Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20799443AAA;
	Thu, 30 Jul 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423445; cv=none; b=B6H9tAnVmsi5Vd2zNV3tPFO/fxj0bRKB7fF8NdHM9GwPFaYyGx3ICySF5Vjz9nKe5+Nrz/VB5rDf3Gd3uoEHa0GcvGYGsG97XdItscw5eZ2BgWUPTwPBZX94qApXxO8rV/rH0ZfeoCg4velWkzydzBYnkyJDIMWH28ro/W2B0Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423445; c=relaxed/simple;
	bh=G0xAmUnJG7xF4cbTO/Nht6+SATqB21iuRwBpZfU/QJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thNViK533fbfJwOcGdIkNsfRuJrz8I04sDwImRdWvQ4vgDXo3isOlUBKemN5yixXY54zj2FuRNJLU/fh9LIIO0cO6c/yOsiYCsWCuKbKw4rh8tu/WXmUX5TYakMt5+q+gjKaTCV2InWuVeS+O/07KfZNUYN78rZfui5Zl/foKno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjADo37F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjADo37F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD261F00A3A;
	Thu, 30 Jul 2026 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423444;
	bh=QxQm8ugMUY2eJKTfVp1j13nKJ3X5Uz1UBup7NWjG9qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjADo37FF/gmy6OqdSpKbHhcuZk8KX9NsLd+HZ7PuRdp0qgxA0+qFgUEItOGNLF+C
	 v/P02rW23tvk3XWWlEtqYTaq0beSaDrsAfPO8GDzEpDQbMRKIURryEuMRWStoAjUfv
	 TXSfV73yOIDEjvofP9569ktjs579ezYl+JSfz22Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/675] Input: ims-pcu - fix logic error in packet reset
Date: Thu, 30 Jul 2026 16:05:59 +0200
Message-ID: <20260730141445.740241874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c837094c498ed..168662a2cc890c 100644
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



