Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93923B1016;
	Wed, 30 Sep 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792161; cv=none; b=fY6Xamilmp2PG8N87emdTxoON/HP68+NxulEvZKZHJNEo2xiBYBbF4ENHDC0UsVAIhjO9QBtt3FzMQvqWrwx+fA79r997laYdhaT+WDKO8dwQyM/MihcbLf5WyJiI1SlBEfhQapLLWfqQcCPnPok7IQ92tB8q7gq/V1L5N19roI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792161; c=relaxed/simple;
	bh=dc/OuTjsodKYgH3Qh2RbtEeiNrTKsM/N9DmUUHdL7uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7j9CF3ATg2Vp3e8tw2hBzWRER5ICm3bicFptb+175EaFjAqfuwBB2GVIW/6uvHICReLoJiwWVff8N84XK5VuliZd4GkmclP+5j5rG2WXhMf6VaMapa8k6uGdEUJL2dWChB0h1J+dpxD2d7uCMQdw4lpRq3cNHhnWkVP9BtuFso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulp/AJW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulp/AJW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1976B1F000FF;
	Wed, 30 Sep 2026 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792160;
	bh=DNRQMrFQx62pK8aNa+DU3vZoI0tVfzTVvVL6sX41+Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulp/AJW7WFxkL3IFtKXi5HhviiPIsfvv2hgNkgjWp143MWb1s9/9Ty7fVFPV47tWh
	 YOuRK8D4Y2ofUtKyv0XvGGTWlajV2mmFJ/O6FT7sl6JFw21P417aHe6odw6cJ3Ycdq
	 PVZs8BhGTi9C5Nsnl0iKko2VY5KnLl53G3OErBPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 555/752] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 30 Sep 2026 17:27:05 +0200
Message-ID: <20260930152410.253664835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Chris Sommers <chris.sommers@icloud.com>

commit 25e424eb4ae1a662d9c3573218d06ac32f797fc5 upstream.

On the Acer Aspire Go 15 (AG15-42P), the internal keyboard drops out
~5 seconds after boot on both Linux and Linux-LTS kernels. Keystrokes on
the built-in keyboard stop registering while the trackpad and external
keyboards remain functional.

Testing confirms that booting with the i8042.reset kernel parameter
resolves the issue and keeps the internal keyboard responsive.

Add SERIO_QUIRK_RESET_ALWAYS to i8042_dmi_quirk_table for the Acer
Aspire AG15-42P to automatically apply this quirk on boot.

Signed-off-by: Chris Sommers <chris.sommers@icloud.com>
Link: https://patch.msgid.link/20260907182723.2709981-1-chris.sommers@icloud.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -265,6 +265,13 @@ static const struct dmi_system_id i8042_
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire AG15-42P"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-432"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)


