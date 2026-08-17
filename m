Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C4915E5BB;
	Mon, 17 Aug 2026 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976515; cv=none; b=Y+5PFlubO36VmFkzkwbdUWA6hDPpBwpeROY8FqC6xjtgfoi10Scn1/qT6j9ACzq1WtJvUcoR/W1wpHkRaBvSxPhxJUfoNmxliXb7tMg4h+Z7WCWogqr4CICRVlw8+/eqO35nJmfJ5dIeVRoKqOXbMKnaT5yYQymk6bHX+JjyqDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976515; c=relaxed/simple;
	bh=tyDrdKzOVD3vl+T4a6B5ROTrVJlM8IP05XwOBgirACk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0CjnTZjoWVuaqO0RzNmQMN5+jZS6BCtQjyd34Ak0QD3ndnfCUI/TYUQOfJejoGOkVxpbukxp9Lu1daZBWlgmGL2PZaef5ErFaBZr1veG2cA2TMJlcQKbtqIGc6MuR68EAKZZde44veaibAHX+ESIA7f/+WBeTtR48hER8vc9ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbBTpPB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbBTpPB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C891F000E9;
	Mon, 17 Aug 2026 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976514;
	bh=Orp4/RH/V0pq+naaEuepTkpZi3+ue5la4IOzvaChHzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbBTpPB79StHKZ9U6iEoqhsnz3j9JfEEViYsQ4UXja1n7fdTyr4kO4cFyYkUf6PxR
	 B5+7cFm62ny1sUV/CaJ8k3KVbUopJrhmPcH08oVD7kNMNQQsIPkUEHC6XGuBRzmmc6
	 yyJue+LN1+iVt5l3Gh4lKxYY0iGsZ5E4YpsFYpEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/456] Input: ims-pcu - fix logic error in packet reset
Date: Mon, 17 Aug 2026 15:26:40 +0200
Message-ID: <20260817132540.273854669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4e7dd8a993737..6b1d8f92a9bb06 100644
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



