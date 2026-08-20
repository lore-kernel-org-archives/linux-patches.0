Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB0836212F;
	Thu, 20 Aug 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239455; cv=none; b=Idl/aTBUWAWl0E0cWPP+FELyJSzcZmqg3bQwv3ipFXWYikwgeeEOsglfS6ouuvwRX9G3AhvScHddrvVGpkemU3gWVr9P09/K/UG9zD68rBKnTfnc6bbOU26mDEtzIOUxhSPDFUfpVsLdvX0Rf8Z/CAWt3RmSsYxzDV4o8FC40Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239455; c=relaxed/simple;
	bh=EiUstOsdhYidtxCAoEIB86RjghMHf7D2A95ZkiyrOX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j00oa+S31Hp3YF9+qoLa0PMgLsDIQ5obfBRAP4Th5R4jfJEXDeOjy8x1it78YXq7tRsEep7wiTUCJErdOGw+wHDgtho9giYA0b+ef14JAxK2MPrRhiYAajeLWWp1ynCO9Ws1i8+BaaSeLZTnsxq3gL1fKYnoLUIdPd4cbL77lGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHAc8uEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHAc8uEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63BD1F000E9;
	Thu, 20 Aug 2026 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239454;
	bh=LDpSdA+njhGGfqIvp4Klw03XLyc/8xtTHik8u7U5YZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHAc8uErLPpwwvBg6/QEb+M4qOY0/WfidTJd/ActhZeVUVwUrxNds359Bo74iQan9
	 miYM5egiF9OkcEOq1blW+X1Mj6iuHL7KsMecn1rx07ko6XFe1vUW82i+UlXqIA9Qse
	 4PYETIqo1pXCvc2iSJTtWUuHMklkFgDoXPkqGLUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 053/220] pmdomain: arm: Fix -EINVAL from scmi_pd_set_perf_state() on state 0
Date: Thu, 20 Aug 2026 16:54:03 +0200
Message-ID: <20260820145225.089457147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

commit 3314c90a2eda3df7da4ab6f4388e667b2758de7f upstream.

Currently, scmi_pd_set_perf_state() treats a performance state of 0 as
invalid and returns -EINVAL. As a result, devices attached to SCMI
performance domains can report failures when relinquishing their
performance vote.

The OPP framework use performance state 0 to indicate that no performance
vote is required. For example, dev_pm_opp_set_rate(dev, 0) is commonly
used (by firmware or linux)  when a device is runtime suspended.

A zero performance state does not require any SCMI performance request
to be sent. Treat it as a no-op and return success instead of reporting
an error.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Fixes: 2af23ceb8624 ("pmdomain: arm: Add the SCMI performance domain")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/arm/scmi_perf_domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/arm/scmi_perf_domain.c
+++ b/drivers/pmdomain/arm/scmi_perf_domain.c
@@ -33,7 +33,7 @@ scmi_pd_set_perf_state(struct generic_pm
 		return 0;
 
 	if (!state)
-		return -EINVAL;
+		return 0;
 
 	ret = pd->perf_ops->level_set(pd->ph, pd->domain_id, state, false);
 	if (ret)


