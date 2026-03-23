Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122E3396B85;
	Mon, 23 Mar 2026 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282440; cv=none; b=KmPUHDw8YdnhNIt+jwUzany3W0IQc9SZLdGx1/9O4fsJS+j1expzubxTYCig20T5OAdr+OSrglg4+QE5Cgk9NNTEOn2WHkWhsulwQ8B3abMbyHWacXEYQT4WvjkDfJNZlbi76xdwxemhXpPAOjQla7TZeCNdif3+NMURLJbZxzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282440; c=relaxed/simple;
	bh=BSPpF51XCKwF23XPHFS7T9ncIVFgWgeoMsvH5BiBQPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHgEDjpbfptbPzrtQBjGuOfHY4UDxzuc4xdIJrTFlQVJ6AZCiym/5UNFjTocg9pOoCXkWVetJE0KazNAu6QqiXqqxqlWmoxwj+JgyT1/X4vC4GAM4E3d/ZL4IL3qv8ezv5wNK/mnNIsf0OyTtMVkjffXqKiuN/oD5wl0axAQWBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpf+QBlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpf+QBlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E54C2BC9E;
	Mon, 23 Mar 2026 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282439;
	bh=BSPpF51XCKwF23XPHFS7T9ncIVFgWgeoMsvH5BiBQPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vpf+QBlbpPhE6S6ILU5smBCecyPuwGBi1C2Ah5uGZtVjXIBInzybi4pQqeEu0gkdn
	 ptgiKy5PfYgqTio6ML1wb4mY+DN9yHOS6MV6Kt3HP2x3YWTaFHPfPclybwW9rvGPrO
	 xj03YhgoOhsr8KXkP/jxBu0DEXPxS5n++C5oSG0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/481] remoteproc: sysmon: Correct subsys_name_len type in QMI request
Date: Mon, 23 Mar 2026 14:42:19 +0100
Message-ID: <20260323134529.064183990@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 15af52f8499eb..78786e08f4f56 100644
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



