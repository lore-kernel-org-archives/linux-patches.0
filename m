Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A855635BDDD;
	Fri,  9 Jan 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962721; cv=none; b=dhUOlnCfqtlKy7glSgvU5r8/ECU+4cKd9WTz8SMcfqn+xBTeHs6nNaAXdRmeYZpDH/P5jZIQhI2NpvigqYrOuMtOfEsBH5Q2Ri58MaFXKvWqyzJ3mFNaSWrqzvAxNpwoIrH3IPKTZJbInk20rXxTHXRR7uLUUaNK5fNMyaYvZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962721; c=relaxed/simple;
	bh=IJEkLNGRnvafm35lAn0vDbLjG/LFKB2g/Rh3yjUwzUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6Kq2lHC+wDc189Kz17AEcsWoPKQGnHrcM+P1hE9JLd5OgVJpip14dfb+HHbrbdbjHK5UPuQdxczSxgXfsGHmhPSEbTghtHpxNmlHZi14s+S35BR6dJUIUBUI6ZR+6Qnsv6Xhe3QwtvpZ2BEp8KMP6+R9haX43vipJoXEFdF3PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubkXfn+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubkXfn+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECAC4CEF1;
	Fri,  9 Jan 2026 12:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962721;
	bh=IJEkLNGRnvafm35lAn0vDbLjG/LFKB2g/Rh3yjUwzUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubkXfn+/iIC8Wsv3DoIKuRKGC228dpP2yF0lYSQAoGQqbjIDzfW/dTm5felyP++TF
	 MltGIDkVy2Npntv72OH6xOsX/yUtkjwOqD5Vh7bOD3RZOm2RWlHhasC/uAah0AMWbZ
	 210mF87Ar3MMhmhuMdTuwRhua4mt4/v7/ipzW9U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 465/634] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Fri,  9 Jan 2026 12:42:23 +0100
Message-ID: <20260109112135.046758326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -118,6 +118,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


