Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D7415689A;
	Mon, 16 Sep 2024 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488461; cv=none; b=YjgPx1d3DKiZqJ9e0/w2ca/uySwrBiEjPb99Zzn3rnRKkNx+A1DWhIgdkVJDt+wDGDA6X6J+sxfYkKQSgxmFIuLarhQ/N/WnQPDAbUYzlf2IDLr4PvmanKxcxb1ReJjsBZnmUaj2Ijsg0K3pAg+HTr83uBhDQ34lkH5/OauapXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488461; c=relaxed/simple;
	bh=vERet8TUWSl4Xcqo3lquhTwiGWnJbNDZnR4NPt1cEng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndqY01N/ZeoiCdU+gwRrZfeP7iHGjrGNCNFM2GK1dQY7JtW/t9it/aqqqhvbF/HAxVk7KpuhhAJFjgi9b38eaV2F7m37JY5yO/GlRB2Zg820OJMCRyH375TpM3EgHm8b+PYEbXgrmMsHcS88rRt1SMVtGKT/nxJtLgZCES911Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fw5uH8BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fw5uH8BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1C8C4CEC4;
	Mon, 16 Sep 2024 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488461;
	bh=vERet8TUWSl4Xcqo3lquhTwiGWnJbNDZnR4NPt1cEng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw5uH8BZ5h30LMYIZqEkx7B7z9y8DxW34QZhJVc2HM41m3uXyNma6YmUDa3A/wNxr
	 WbWC1bzNMR441pIbBJocb22wGXleSxZTohyBfHJhZyAHqCkooqdwiJKGzdCtClfWwd
	 JfljISFPIrsWogxKgrFd9CF+wjybcz0h22oVT+fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.10 121/121] usb: typec: ucsi: Only set number of plug altmodes after registration
Date: Mon, 16 Sep 2024 13:44:55 +0200
Message-ID: <20240916114233.114262527@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

commit 22d96a285449ba78abeaf3e197caca46bc24f8e5 upstream.

Move the setting of the plug's number of alternate modes into the
same condition as the plug's registration to prevent dereferencing the
connector's plug pointer while it is null.

Fixes: c313a44ac9cd ("usb: typec: ucsi: Always set number of alternate modes")
Suggested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20240625004607.3223757-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1176,13 +1176,13 @@ static int ucsi_check_cable(struct ucsi_
 		ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_SOP_P);
 		if (ret < 0)
 			return ret;
-	}
 
-	if (con->plug_altmode[0]) {
-		num_plug_am = ucsi_get_num_altmode(con->plug_altmode);
-		typec_plug_set_num_altmodes(con->plug, num_plug_am);
-	} else {
-		typec_plug_set_num_altmodes(con->plug, 0);
+		if (con->plug_altmode[0]) {
+			num_plug_am = ucsi_get_num_altmode(con->plug_altmode);
+			typec_plug_set_num_altmodes(con->plug, num_plug_am);
+		} else {
+			typec_plug_set_num_altmodes(con->plug, 0);
+		}
 	}
 
 	return 0;


