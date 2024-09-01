Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD21C68C;
	Sun,  1 Sep 2024 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208983; cv=none; b=uiYjLpX/3PHttGyWzRwL32yA+l7bETGFQwlGisut922fKPZjlsv1qBqmaMN32H5NbIzgDG8Tgaed/Wu97YQxgHrmZm87ror256QT99vdJjjxLR80JVxj3cAQLA9YesUWTJLZm9cYrBNlLFNK7rg5yks+2MeHPEzkhKoHM9OacDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208983; c=relaxed/simple;
	bh=Afkp9BNXa3p5fzPy9CVZN2u/c/I21UQ3ir77R6nDyyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tslsPQQ1+q0rupm21okBFB7JrWlcdexQSK6D20zvitDsAWlAIzbLb2ij9Iuly2r0LSzMEXga4F3Fc5qx8P+ojyzYOUlw9iMyexudhQWVLFHyUfl10hhGgGKkne6EMD2mcK38ObznjDce6SXKnB4hvMYGBSdT3MWkcVOC8+s+FFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAlSRHWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAlSRHWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7C0C4CEC3;
	Sun,  1 Sep 2024 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208983;
	bh=Afkp9BNXa3p5fzPy9CVZN2u/c/I21UQ3ir77R6nDyyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAlSRHWZgCNMME+wrAASyq+yC03TgDz9XlylKuouxbTPj2E0d6GMBy8xMElRlUpd3
	 V++/62UWk+xGgaK5qlbK8qYt0l6c3n3F+7Hw+Ac4cI0nx5rdDuA0ypWvk1IJlp+rgZ
	 6tZGVuACyPXUwQkN31eVpyFkMJZDW0s2mXtSFfs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 099/134] HID: wacom: Defer calculation of resolution until resolution_code is known
Date: Sun,  1 Sep 2024 18:17:25 +0200
Message-ID: <20240901160813.818146965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 1b8f9c1fb464968a5b18d3acc1da8c00bad24fad upstream.

The Wacom driver maps the HID_DG_TWIST usage to ABS_Z (rather than ABS_RZ)
for historic reasons. When the code to support twist was introduced in
commit 50066a042da5 ("HID: wacom: generic: Add support for height, tilt,
and twist usages"), we were careful to write it in such a way that it had
HID calculate the resolution of the twist axis assuming ABS_RZ instead
(so that we would get correct angular behavior). This was broken with
the introduction of commit 08a46b4190d3 ("HID: wacom: Set a default
resolution for older tablets"), which moved the resolution calculation
to occur *before* the adjustment from ABS_Z to ABS_RZ occurred.

This commit moves the calculation of resolution after the point that
we are finished setting things up for its proper use.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Fixes: 08a46b4190d3 ("HID: wacom: Set a default resolution for older tablets")
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1920,12 +1920,14 @@ static void wacom_map_usage(struct input
 	int fmax = field->logical_maximum;
 	unsigned int equivalent_usage = wacom_equivalent_usage(usage->hid);
 	int resolution_code = code;
-	int resolution = hidinput_calc_abs_res(field, resolution_code);
+	int resolution;
 
 	if (equivalent_usage == HID_DG_TWIST) {
 		resolution_code = ABS_RZ;
 	}
 
+	resolution = hidinput_calc_abs_res(field, resolution_code);
+
 	if (equivalent_usage == HID_GD_X) {
 		fmin += features->offset_left;
 		fmax -= features->offset_right;


