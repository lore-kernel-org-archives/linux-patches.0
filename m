Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A55332909;
	Fri, 17 Oct 2025 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714339; cv=none; b=DT5w216JLkBi49ofF+3m0mdKB9QzGlXbVuWD5PjxVe4CeV7KPCyEeuKCc3Cl0CwdOOTl9z9XjObtwo/nVpmAxOB6KAMpVFCK6kHKaerOtTtlwS2Uzx8ya2g6/8hX2neV0kgVUEbRgupQRvpgCDavh0q3koAjNvPgA516Vf8lric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714339; c=relaxed/simple;
	bh=RdHLbeC5K4TyEc14wkePHdOJ/P9tZH7QVig7VueiOQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBxJaHdt/1RoGNKf/dPMg2EOVyWs0zoMtDzETXDJsWQgoOpMe2ce3CjiMbkSZNSoWeOOsh1EWDrXvQSRh9FUFqj9FDOtihZK3+9DuUVOTcp4yrmk4zq6JN4nNWPtanrTKvV6EJIX9P08vpq+cZwePAqXOkF12W6SuDVjHzymthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWqXzjbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWqXzjbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A280AC4CEE7;
	Fri, 17 Oct 2025 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714339;
	bh=RdHLbeC5K4TyEc14wkePHdOJ/P9tZH7QVig7VueiOQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWqXzjbNshVsxlyR4Li0RHAKwEXcx/GkwF5JZ8TzfwKz7jHI1mdPYO8wrsirlNsJd
	 VhXgWvhCdYlNXozdDPTPgPsrBX74Vb07x+tmAKcdUZ4mB3SYrjcamtszQsbUcZf13e
	 yiAO9SQZOZ9ZI2r+/KQ710+JIfq2gx21n8H4oDTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 111/277] media: vivid: fix disappearing <Vendor Command With ID> messages
Date: Fri, 17 Oct 2025 16:51:58 +0200
Message-ID: <20251017145151.180119544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit 4bd8a6147645480d550242ff816b4c7ba160e5b7 upstream.

The vivid driver supports the <Vendor Command With ID> message,
but if the Vendor ID of the received message didn't match the Vendor ID
of the CEC Adapter, then it ignores it (good) and returns 0 (bad).

It should return -ENOMSG to indicate that other followers should be
asked to handle it. Return code 0 means that the driver handled it,
which is wrong in this case.

As a result, userspace followers never get the chance to process such a
message.

Refactor the code a bit to have the function return -ENOMSG at the end,
drop the default case, and ensure that the message handlers return 0.

That way 0 is only returned if the message is actually handled in the
vivid_received() function.

Fixes: 812765cd6954 ("media: vivid: add <Vendor Command With ID> support")
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-cec.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-cec.c b/drivers/media/test-drivers/vivid/vivid-cec.c
index 356a988dd6a1..2d15fdd5d999 100644
--- a/drivers/media/test-drivers/vivid/vivid-cec.c
+++ b/drivers/media/test-drivers/vivid/vivid-cec.c
@@ -327,7 +327,7 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 		char osd[14];
 
 		if (!cec_is_sink(adap))
-			return -ENOMSG;
+			break;
 		cec_ops_set_osd_string(msg, &disp_ctl, osd);
 		switch (disp_ctl) {
 		case CEC_OP_DISP_CTL_DEFAULT:
@@ -348,7 +348,7 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 			cec_transmit_msg(adap, &reply, false);
 			break;
 		}
-		break;
+		return 0;
 	}
 	case CEC_MSG_VENDOR_COMMAND_WITH_ID: {
 		u32 vendor_id;
@@ -379,7 +379,7 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 		if (size == 1) {
 			// Ignore even op values
 			if (!(vendor_cmd[0] & 1))
-				break;
+				return 0;
 			reply.len = msg->len;
 			memcpy(reply.msg + 1, msg->msg + 1, msg->len - 1);
 			reply.msg[msg->len - 1]++;
@@ -388,12 +388,10 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 					      CEC_OP_ABORT_INVALID_OP);
 		}
 		cec_transmit_msg(adap, &reply, false);
-		break;
+		return 0;
 	}
-	default:
-		return -ENOMSG;
 	}
-	return 0;
+	return -ENOMSG;
 }
 
 static const struct cec_adap_ops vivid_cec_adap_ops = {
-- 
2.51.0



