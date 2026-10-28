Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216643;
	b=lQiGC4xIOquy+KPDXY4bc1CmhozLTXkv8Wbfce9M+kaL30dBKp39uq8p+RMCsE63s1ta
	 yq64kN5U08q8UbYUTS9l6VoJPu1n9MYfyQepIEOEtVpqZUS6cRMYuIFnZnpJ2pDve6r5c
	 I3b0juioaKlrnfYtGGYgIdfhmO4gmwM92clui6ktVzP9pzzqO4mkwgAfcDkfdDnv2v88+
	 N5agCtlyaS/z3pBhzPfBtCzmff2tMCDLsxkK//jc3j4d8HVZSSHPX7+lhy/tAxmkryZFU
	 e9lsCA/zVgWiBOLrWx6LUzyOzz0gDRBzpfFtUG+OAhCjs0UiEy+EH2QWbmCWLbRXsiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X4EUjhO1ijCAHo1S5ih0lvQtgEM6IRm0FvEDE7tBSNk=;
	b=0LMVlTpv6e3+OmwbDO3ni/pi0erIYh7BqlT23NaFOtNxxRnLeSgiipFdkqv4won1ahIt
	 gbAgivcEb2SCJipNfXh4V1ctmWvyppmad8jxn7yQ4UUsgMhUYk0lREYygxn87PfBtwlg+
	 ZTwnr/BeqPA1E7xB0BtijbEY/VlVRiP5sXuS4kFrrPckNorQ0S6TdxHL+Pf+dUg86TrvR
	 ebbrLTDVNss0p6ZUkM3Ne6x0aedhhgfAzX6v2WoDHt4oVmjxn52ZI+gU/Auah1lNZSVKX
	 pa0pD2rw1mDXP6DdXXfmcdxEdgq2SHTMs2DptbiqZm/iWgG/hOGj55nmj9HKtox9wsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLNnFV83;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B24606A31C;
	Wed, 28 Oct 2026 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLNnFV83
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567841F01825;
	Wed, 28 Oct 2026 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216642;
	bh=X4EUjhO1ijCAHo1S5ih0lvQtgEM6IRm0FvEDE7tBSNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLNnFV83gj44iyxbd4LStf6O/vErtzUq5MmeuNIshwrdgfVmwug+QRgq+MoHZhrBq
	 bF+n5Tdf00pfe4f9B5HapX9JSzHKiHHaw93utLNgf8tVpMrivl2XqO6QWmBNNnwPDm
	 wTZs2uOW/HRzgkpAwrXwgIwKAdWP2RCR2R842qG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1627/1887] platform/x86: asus-wmi: fix resource leaks on probe failure
Date: Wed, 28 Oct 2026 18:02:03 +0100
Message-ID: <20261028170536.492129457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit ef3daa2b84a2b8499ce9e2ce1c865dca36d39f95 ]

During driver initialization in asus_wmi_add(), various subsystems are
registered sequentially. However, the error path labels are out of order
relative to the registration sequence.

Specifically:
1. If asus_wmi_custom_fan_curve_init() fails, the driver jumps to
   fail_custom_fan_curve. Because this label is placed below fail_sysfs,
   it bypasses the cleanup calls for the input device and sysfs groups,
   which were successfully registered before, leaking those resources.
2. If asus_screenpad_init() fails, the driver jumps to fail_screenpad.
   Because fail_screenpad is placed below fail_backlight, it bypasses the
   cleanup calls for backlight and rfkill, leaking those resources.

Fix these resource leaks by reordering the error path labels in
asus_wmi_add() to match the exact reverse order of the resource
allocations.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Fixes: 2c97d3e55b70 ("platform/x86: asus-wmi: add support for ASUS screenpad")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260617155104.10111-1-scardracs@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 73bcebab27694..8814b258caa55 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3859,13 +3859,13 @@ static int asus_wmi_add(struct platform_device *pdev)
 fail_rfkill:
 	asus_wmi_led_exit(asus);
 fail_leds:
+fail_custom_fan_curve:
 fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
 	asus_wmi_sysfs_exit(asus->platform_device);
 fail_sysfs:
 fail_throttle_thermal_policy:
-fail_custom_fan_curve:
 fail_platform_profile_setup:
 	if (asus->platform_profile_support)
 		platform_profile_remove();
-- 
2.53.0



