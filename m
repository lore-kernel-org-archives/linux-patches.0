Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DE71C1F12;
	Wed,  5 Feb 2025 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766622; cv=none; b=g5+/m8SNPhYdYZZg4KENnw2uB3ZIPJUakJvyKrVD1op8I9JRV9oQ74zDiyzB7cqwMpGti3Xn2a8yPS6otBi8TRYbarOsaF6UEyP4tAdQN3Cy0reQv08ZNsI65zbvYaFSanBXoIEo0WVh2N9pfmdROQr6HZVewlAzUWY5t+xBjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766622; c=relaxed/simple;
	bh=vKY7DELQDJ5DWCxE5Rvqo2wrU6X8Nmhyras3akPAMqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raBs5k9LEKzxdjPmOhRKBF2Oc0yJ48Da7A4JfJjX9Q9nk20PWCE1Vj9GTyl/lIYyolQ4eavGgkDVUUZBOaY+Z/3VHHtXG8+Zur1gMlg3gf0ZfSEbqEyADlV0eBi63D+pzemvYxiJPpLej+EqjkBks19T6ssJEVeCCiZ4w+zX04k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDHv7e1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDHv7e1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F12EC4CED1;
	Wed,  5 Feb 2025 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766622;
	bh=vKY7DELQDJ5DWCxE5Rvqo2wrU6X8Nmhyras3akPAMqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDHv7e1Ao1hJzL7DxwfKxUEnFNu1yGki8wa/MqJORRcCc3oYBsMNRbr/iDqJApKZS
	 eRe+c6hWoM9fK8cWwt/5GoLGsEptHNpwca4CIbOXhlowHo1ZGjpGypCK6fh0839ZRW
	 /2tt3tUevjTizOXGXZTQp5HbcI7BOf3D7T7IVyps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 379/393] usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()
Date: Wed,  5 Feb 2025 14:44:58 +0100
Message-ID: <20250205134434.796347028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit a266462b937beba065e934a563efe13dd246a164 upstream.

phy_syscon_pll_refclk() leaks an OF node obtained by
of_parse_phandle_with_fixed_args(), thus add an of_node_put() call.

Cc: stable <stable@kernel.org>
Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250109001638.70033-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -160,6 +160,7 @@ static int phy_syscon_pll_refclk(struct
 	if (ret)
 		return ret;
 
+	of_node_put(args.np);
 	am62->offset = args.args[0];
 
 	ret = regmap_update_bits(am62->syscon, am62->offset, PHY_PLL_REFCLK_MASK, am62->rate_code);


