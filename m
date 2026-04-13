Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7A83016EE;
	Mon, 13 Apr 2026 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097339; cv=none; b=P+vXrEeYj7H4VqBnkC8Rb802RiMeZQmFK5ZO18T0ouVgssxvvC9Ji6sBkPmDpJxOIqIRznsGc9XaHHXvaL2pxediL9y0EHryXJqAISJM5gT4L/RBcr3cE4jvs7IUD7G3ctWKf7qPNDo9KHbqLgWUYIfdSQV/J68AmJuvysbQYjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097339; c=relaxed/simple;
	bh=VE27NiNdcyjJOFeAIVVLsDrASmyQgJB1lUZmWQAgd6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHPf0GjDB2zrO1A80PVz3Ronab9+CGh5d379coqud/VGUqEBO3J1Q9rCepAk2ZGTWujfBboS9Su2+o34Xhn7dO69hk84Z+8hfufsp3SdNGk7PjwtWb5cIm38o+XcvmFDbDqaWg2PLq791OU4PtUzT3bqRipXnD+s9EWLNTkQlw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlWWnmiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlWWnmiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F09BC2BCB0;
	Mon, 13 Apr 2026 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097339;
	bh=VE27NiNdcyjJOFeAIVVLsDrASmyQgJB1lUZmWQAgd6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlWWnmiuconQrhUC3Se88eThGT4T6/qViLD4e3DE9d9OXaq+t5nFJTPrdG/4QmfAe
	 bmytlAfg8uuvmBbfMb0W5c4Mw0zZe9nYGU1FWpvGsdheKtzbgjyX+0pg4Sy0HwtyK1
	 bDSLbukYOCQoxER/oDlQWHuyVl0sT2eKr+/ylSFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/570] remoteproc: sysmon: Correct subsys_name_len type in QMI request
Date: Mon, 13 Apr 2026 17:53:50 +0200
Message-ID: <20260413155834.152485761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit da994db94e60f9a9411108ddf4d1836147ad4c9c ]

The QMI message encoder has up until recently read a single byte (as
elem_size == 1), but with the introduction of big endian support it's
become apparent that this field is expected to be a full u32 -
regardless of the size of the length in the encoded message (which is
what elem_size specifies).

The result is that the encoder now reads past the length byte and
rejects the unreasonably large length formed when including the
following 3 bytes from the subsys_name array.

Fix this by changing to the expected type.

Fixes: 1fb82ee806d1 ("remoteproc: qcom: Introduce sysmon")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Chris Lew <christopher.lew@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260220-qmi-encode-invalid-length-v2-1-5674be35ab29@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_sysmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index fbfaf2637a91a..28bf1b04be820 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -204,7 +204,7 @@ static struct qmi_elem_info ssctl_shutdown_resp_ei[] = {
 };
 
 struct ssctl_subsys_event_req {
-	u8 subsys_name_len;
+	u32 subsys_name_len;
 	char subsys_name[SSCTL_SUBSYS_NAME_LENGTH];
 	u32 event;
 	u8 evt_driven_valid;
-- 
2.51.0



