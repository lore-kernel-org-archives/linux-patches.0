Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB2D3EC2EA;
	Tue, 17 Mar 2026 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765464; cv=none; b=d66rcQzKp6y6j828Vz8fPZQhD7jPFR98X/djmVgnN/4Ts2irXLQmZUZogpu9pHddFFFaMAnLnSVBERXvpaxxi1uBHZJsL34ctyBQNG8QTKqzJBmxTSY2RIOi1qJe/VQ6YLIfqpkW+wISSDtWtOrvalGvYBmURVLwlc5Lvb5f9Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765464; c=relaxed/simple;
	bh=TzMBZvDDeK05ZzI2Kjsl70nMWMh1Ji3e7oqNwSliVgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMxNjA2d84/yBH/LD4LOnvoITJKBpa9dy8S94f1KH077AIYfvnxKMDCdZ7Sp6hNOQNbwRZfhhqSWSYUrAFgZUGfZFJM1u98BPw8aaoABb20szJUGnu7ANzg9IiXw8bvHp0yHgjFJIedXloMGMMBCBIWbUEthV/g7XUv9Ir2rWUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnyaS9KC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnyaS9KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECFC4CEF7;
	Tue, 17 Mar 2026 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765463;
	bh=TzMBZvDDeK05ZzI2Kjsl70nMWMh1Ji3e7oqNwSliVgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnyaS9KC2+LTBWP1fyh/XrxB+DWqzQyolQcg/RdjfJJIIC3lvZ7IuRADRt38sMFCg
	 iBbTyD0PKpU7r0Uy1Gp+poyVnQNFU0ib5FhVqdgWzhIGctj+5EcljpkVhx6GHVHU7q
	 o2VwIl6HIVNhqG5dpMn7QMWGA0Gw4Riplfgg3cMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 017/378] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Tue, 17 Mar 2026 17:29:34 +0100
Message-ID: <20260317163007.608989716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sofia Schneider <sofia@schn.dev>

[ Upstream commit 5ede90206273ff156a778254f0f972a55e973c89 ]

The screen backlight turns off during boot (specifically during udev device
initialization) when returning true for _OSI("Windows 2009").

Analyzing the device's DSDT reveals that the firmware takes a different
code path when Windows 7 is reported, which leads to the backlight shutoff.
Add a DMI quirk to invoke dmi_disable_osi_win7 for this model.

Signed-off-by: Sofia Schneider <sofia@schn.dev>
Link: https://patch.msgid.link/20260223025240.518509-1-sofia@schn.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/osi.c b/drivers/acpi/osi.c
index f2c943b934be0..9470f1830ff50 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -389,6 +389,19 @@ static const struct dmi_system_id acpi_osi_dmi_table[] __initconst = {
 		},
 	},
 
+	/*
+	 * The screen backlight turns off during udev device creation
+	 * when returning true for _OSI("Windows 2009")
+	 */
+	{
+	.callback = dmi_disable_osi_win7,
+	.ident = "Acer Aspire One D255",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AOD255"),
+		},
+	},
+
 	/*
 	 * The wireless hotkey does not work on those machines when
 	 * returning true for _OSI("Windows 2012")
-- 
2.51.0



