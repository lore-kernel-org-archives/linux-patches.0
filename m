Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0598532AAB5;
	Fri,  9 Jan 2026 12:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961008; cv=none; b=V6r6jgCygi34ZPoyx5DEYwxst+OK0NA7kyYcGNSq4Q6ENVZ5MNlBm1j6kW5srZNy5R0yXX2+Vw8qrIGFDVkLzTRvbgvXlqQpu1A0HXrOHZcztbzwXsI5OMHJsCmixo0VWW3sGYcnc9JFM5cMmqe2doyixzoxnnygBmfQmvmcars=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961008; c=relaxed/simple;
	bh=qNfxPSzr5SHuShxPuswG0dL6xpTfTH1u7hmaJ7R465M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOZDiWZc4I7EHYK5cAaKewiarE/G5lu7YD5m5WnHkLkyOy4+yc7dLDphIWAGUEzcmkgnnbpWANLjwWLzuGQLQkjy97OepTXYV6btL22jVo5dzSXB63q3iR/Wj1d/spPPaVGke65E7xu8KIzmC1v5VC/cO93TXOsHqGlARXGlly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vt5CkI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vt5CkI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D12C4CEF1;
	Fri,  9 Jan 2026 12:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961007;
	bh=qNfxPSzr5SHuShxPuswG0dL6xpTfTH1u7hmaJ7R465M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vt5CkI10dC+QgD0VWEpz08jE4wq+E93osCS/bKEcrs9NB+2QEtmnYOr9jC1G7Ebl
	 YQ0NnVJyMtNDSnUUjLZ+O/6wMq03ejy+8atJWbAiW8/2HqYg+1gebK0Fo0kxZ9k6vp
	 iJEtti/RqH3RLDQ/YZMExRuQebcV3ii1pmr9ILb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 570/737] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Fri,  9 Jan 2026 12:41:49 +0100
Message-ID: <20260109112155.442622571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ccb7cd3218e48665f3c7e19eede0da5f069c323d upstream.

Make sure to drop the reference taken to the sysmgr platform device when
retrieving its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: f36e789a1f8d ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
Cc: stable@vger.kernel.org	# 5.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/altera-sysmgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -117,6 +117,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


