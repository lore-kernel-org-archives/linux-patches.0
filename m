Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D472FFDEA;
	Tue, 17 Mar 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767138; cv=none; b=jEXJ0ym139lmOkty3LeseMAiFiEycudNzrvRECcDhz4l61dyoou2ayK4MQTfP20Hwxma06d65mDQUbGO55IfNQKuPXk0SjY4fXsutSRnH0aKvBZX/SmHlgtcURLTeJG4cDgk9BVUOhQGKM6amCz92A6FI5HvuAvzTVgloNWEvvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767138; c=relaxed/simple;
	bh=fjumpfleaci/tPpoOlAqqfvONjeov5e9kHm44GFGatk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQvlNX5ZITBJpDH6II1v94aiE8rdmsnA1unGJGbediFMSgm+4CDgGHNRy8a8q9p5DzLDbEP5zHbXJ+d0TdLipOuxNVder+VoYSozFBBSLG/PVsdg2TWbW0jaBETAEST+4XFUzrGykqe59HZa6J3jC2DZS0W9VBx9IFvTepG1Px4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAnFX01J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAnFX01J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E19C4CEF7;
	Tue, 17 Mar 2026 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767138;
	bh=fjumpfleaci/tPpoOlAqqfvONjeov5e9kHm44GFGatk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAnFX01JLfCN2mTO/D91aO8v/dXbXHNQRuQ+if91T/osr+MU2QYhfQJc1dYr0dliN
	 zF0OI3xlqOAE8rGR3PALTBmSL92x3ytisJYJDBpXTZWhVk05X9avvEbgrGnyjxcGXJ
	 cflez+G6wqe15YNZIOPR/r8b1Hy8jUMQBvnwvG5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/333] remoteproc: sysmon: Correct subsys_name_len type in QMI request
Date: Tue, 17 Mar 2026 17:30:51 +0100
Message-ID: <20260317163000.183916656@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 660ac6fc40821..c6cc6e519fe56 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -203,7 +203,7 @@ static const struct qmi_elem_info ssctl_shutdown_resp_ei[] = {
 };
 
 struct ssctl_subsys_event_req {
-	u8 subsys_name_len;
+	u32 subsys_name_len;
 	char subsys_name[SSCTL_SUBSYS_NAME_LENGTH];
 	u32 event;
 	u8 evt_driven_valid;
-- 
2.51.0



