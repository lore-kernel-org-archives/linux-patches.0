Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C039C53E2E;
	Mon,  8 Jan 2024 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9pCYwxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43726C433C8;
	Mon,  8 Jan 2024 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728696;
	bh=SWTfeiYegvuxary6e2UhhhpbYqGyg9I3csNFIw0iVJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9pCYwxhD+LIQXG0a0k98Xpdo52b7eKZ/P0lRqYiD/ML/LDN7CIcW/NL+2/N/fDpX
	 bktRnAdQBYYcVZmK727MuJNZN2qos6pde1VaHXwjMr8N2DWNR2fQIYpeP7jQlcQjyw
	 Wus6tNXxZJ7V1Dt8T53kdPYfCFCrcf04tT5Lx+xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 148/150] media: qcom: camss: Comment CSID dt_id field
Date: Mon,  8 Jan 2024 16:36:39 +0100
Message-ID: <20240108153518.035312445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit f910d3ba78a2677c23508f225eb047d89eb4b2b6 upstream.

Digging into the documentation we find that the DT_ID bitfield is used to
map the six bit DT to a two bit ID code. This value is concatenated to the
VC bitfield to create a CID value. DT_ID is the two least significant bits
of CID and VC the most significant bits.

Originally we set dt_id = vc * 4 in and then subsequently set dt_id = vc.

commit 3c4ed72a16bc ("media: camss: sm8250: Virtual channels for CSID")
silently fixed the multiplication by four which would give a better
value for the generated CID without mentioning what was being done or why.

Next up I haplessly changed the value back to "dt_id = vc * 4" since there
didn't appear to be any logic behind it.

Hans asked what the change was for and I honestly couldn't remember the
provenance of it, so I dug in.

Link: https://lore.kernel.org/linux-arm-msm/edd4bf9b-0e1b-883c-1a4d-50f4102c3924@xs4all.nl/

Add a comment so the next hapless programmer doesn't make this same
mistake.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-gen2.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-gen2.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-gen2.c
@@ -352,7 +352,19 @@ static void __csid_configure_stream(stru
 		phy_sel = csid->phy.csiphy_id;
 
 	if (enable) {
-		u8 dt_id = vc;
+		/*
+		 * DT_ID is a two bit bitfield that is concatenated with
+		 * the four least significant bits of the five bit VC
+		 * bitfield to generate an internal CID value.
+		 *
+		 * CSID_RDI_CFG0(vc)
+		 * DT_ID : 28:27
+		 * VC    : 26:22
+		 * DT    : 21:16
+		 *
+		 * CID   : VC 3:0 << 2 | DT_ID 1:0
+		 */
+		u8 dt_id = vc & 0x03;
 
 		if (tg->enabled) {
 			/* configure one DT, infinite frames */


