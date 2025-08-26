Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE071B87E8;
	Tue, 26 Aug 2025 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214841; cv=none; b=IUvwnVwXizq1IyKRuAkCbiPeaA1OSqbSh7KV4bIDRg4ci/WpAYvGf+cYcbIfD0L9TC3gCaCvRMWzDHWQ+0PLl4LqSndnVIixWxQ4I/3haT5aVjuzyxR3asrF9jsnMNlhomxQEfn94KLdD4Bnq6ve6vWcVyRx82mgjvikwsWgtKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214841; c=relaxed/simple;
	bh=nS3boUq2Pn6FoDAYog0bwnczl/VLPN/smx04u5kYB5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WazhLblxPpte9MvdtAZjq1fmAskd2WmiKM4H6ggDFX2nNxeY3L2vobu9bP33LzT0+j47bhdeNyklfAWjZHUcvcVTg8lLu4UZG1AbjmqF/gi5aQwx5TePbS2AaqOl+BE0VOp3Q86X6H8ndIGVZWHva06m5h/2RgI2+eMJu8sBngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKQO92C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKQO92C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449F3C4CEF1;
	Tue, 26 Aug 2025 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214840;
	bh=nS3boUq2Pn6FoDAYog0bwnczl/VLPN/smx04u5kYB5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKQO92C2tlQpRIvHLN1UCVmpyk1Qx4Q6vOVyibzRT71h+MAOGdSVI5OSERCp1Blrw
	 48Z2tq3tDjG7DMtAQPTyX7higucntjlb79yETqnm0SFmn8cPYguS+uNv+FiltvD+M+
	 iyG9t5daZcn5hV6DVl1MxAtvcRvBx9pLoQzYq3+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 248/482] usb: typec: ucsi: Update power_supply on power role change
Date: Tue, 26 Aug 2025 13:08:21 +0200
Message-ID: <20250826110936.895443081@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit 7616f006db07017ef5d4ae410fca99279aaca7aa upstream.

The current power direction of an USB-C port also influences the
power_supply's online status, so a power role change should also update
the power_supply.

Fixes an issue on some systems where plugging in a normal USB device in
for the first time after a reboot will cause upower to erroneously
consider the system to be connected to AC power.

Cc: stable <stable@kernel.org>
Fixes: 0e6371fbfba3 ("usb: typec: ucsi: Report power supply changes")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250721-fix-ucsi-pwr-dir-notify-v1-1-e53d5340cb38@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -806,6 +806,7 @@ static void ucsi_handle_connector_change
 
 	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


