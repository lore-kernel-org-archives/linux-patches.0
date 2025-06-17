Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6C2FA622;
	Tue, 17 Jun 2025 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179424; cv=none; b=l+ivULaA/MP/kQTbMIn4Pangb730O0Rk2wNQmu/xWaitXjnrJoMQoKNy3+LNN0MFXs9dernI8ehoDvY45yDlpbGEQOCrW7tIE7OXqpkXxAez8OLj+T7avXi/dP1FDCkvoWwviFOwOCISWkSCc6jf0G4luMGXE37C3iEG6ptHxi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179424; c=relaxed/simple;
	bh=60Fs/y0t45cJ5mI5vWDOaaoH/PtfcYAfKizcunr7nh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nthAZ7bE2w0iSB2RHsxEKoorsdRyvJnogV/7acbR2wuTL2sVoi7OItXQdPuQtDtSZywOoegFuqELUL2ewqqxoS3te9kDSdG2nyjCcGNQAfs/ypJc91d2Y6c+NlA/46HUyuexAWIFrA1osiz/Wl+bD8Wwa+z/VpMc1n4xBCj8KZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW2Mp3iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW2Mp3iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05742C4CEE3;
	Tue, 17 Jun 2025 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179423;
	bh=60Fs/y0t45cJ5mI5vWDOaaoH/PtfcYAfKizcunr7nh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NW2Mp3ivwkkrV8aWJmKbVStT/Dk7DS4sJ8d/WFQeUWZe5+pG+fA8n0eQllVhGRDgU
	 7ktald+hTII3V4buuPUaePWGlJAiLV89vLhKbaCaV8ZiGF93AdY1UXXSuAyZgxxLWG
	 V8AM834FXOX6Ky9axCWY6YGWz2/kMUdTc6zBDUK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Luiz Duarte <gustavold@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 701/780] netconsole: fix appending sysdata when sysdata_fields == SYSDATA_RELEASE
Date: Tue, 17 Jun 2025 17:26:49 +0200
Message-ID: <20250617152520.039823651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Luiz Duarte <gustavold@gmail.com>

[ Upstream commit c85bf1975108d2e2431c11d1cb7e95aca587dfbe ]

Before appending sysdata, prepare_extradata() checks if any feature is
enabled in sysdata_fields (and exits early if none is enabled).

When SYSDATA_RELEASE was introduced, we missed adding it to the list of
features being checked against sysdata_fields in prepare_extradata().
The result was that, if only SYSDATA_RELEASE is enabled in
sysdata_fields, we incorreclty exit early and fail to append the
release.

Instead of checking specific bits in sysdata_fields, check if
sysdata_fields has ALL bit zeroed and exit early if true. This fixes
case when only SYSDATA_RELEASE enabled and makes the code more general /
less error prone in future feature implementation.

Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Fixes: cfcc9239e78a ("netconsole: append release to sysdata")
Link: https://patch.msgid.link/20250609-netconsole-fix-v1-1-17543611ae31@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 4289ccd3e41bf..176935a8645ff 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1252,7 +1252,6 @@ static int sysdata_append_release(struct netconsole_target *nt, int offset)
  */
 static int prepare_extradata(struct netconsole_target *nt)
 {
-	u32 fields = SYSDATA_CPU_NR | SYSDATA_TASKNAME;
 	int extradata_len;
 
 	/* userdata was appended when configfs write helper was called
@@ -1260,7 +1259,7 @@ static int prepare_extradata(struct netconsole_target *nt)
 	 */
 	extradata_len = nt->userdata_length;
 
-	if (!(nt->sysdata_fields & fields))
+	if (!nt->sysdata_fields)
 		goto out;
 
 	if (nt->sysdata_fields & SYSDATA_CPU_NR)
-- 
2.39.5



