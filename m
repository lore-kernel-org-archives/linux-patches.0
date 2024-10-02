Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C2F1D1E89;
	Wed,  2 Oct 2024 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878808; cv=none; b=iCcjkFzvDBbFAMExqtmvq20Rn72OCbfwJwFPdr3LPPLCdaOT2+cA2Uro2KbRpuPl8+KRL4ZjUZZpVW1xaZqVAjegEjvX0VYSKo7G70ls2rwqTML5hWiUKK7c9I0NrCqRvA8u9dexIF3vgcfzHJScdMlymIRnF9XYy2WZMSUKNps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878808; c=relaxed/simple;
	bh=IaFIpnH6GlJqeoNIZRC/NvfQkN8Cj/umGnVFPS9UUw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TG5pm1JuIKlesqy6GEFD0Zeuq/QgPYzZYRMS1TO+7lj0jkNIli4l1cyuVVLWDbV4WCtsQ+L4J7HGNdg6sYbf9VpX6iFsDg8kWHY+oLb4OD91KUaAMlf8IYhh3NMSAmV8Y8DmTU1zSDR7cm3q6/bjzcxk2T0jxeXyv/Sh7nKKuS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWtSmkJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWtSmkJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C203C4CECD;
	Wed,  2 Oct 2024 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878808;
	bh=IaFIpnH6GlJqeoNIZRC/NvfQkN8Cj/umGnVFPS9UUw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWtSmkJO/V6mGt513dCGUKIfY9L/nj5hV+EU6rh2kXSIynAy4lb+1+D6TaXrDWGe3
	 Acn9TESlCrBgnO5IiTEItaIMwMkkHsQ6GKCeirhqNA1tDD3UyYARLNrRAzOUvQM/h6
	 tCuW/9HaeX8gU3TrAkhoOAJNG4tW7JeNcMoF/j7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 508/634] scsi: sd: Fix off-by-one error in sd_read_block_characteristics()
Date: Wed,  2 Oct 2024 15:00:08 +0200
Message-ID: <20241002125831.157098976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

commit f81eaf08385ddd474a2f41595a7757502870c0eb upstream.

Ff the device returns page 0xb1 with length 8 (happens with qemu v2.x, for
example), sd_read_block_characteristics() may attempt an out-of-bounds
memory access when accessing the zoned field at offset 8.

Fixes: 7fb019c46eee ("scsi: sd: Switch to using scsi_device VPD pages")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20240912134308.282824-1-mwilck@suse.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3283,7 +3283,7 @@ static void sd_read_block_characteristic
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!vpd || vpd->len < 8) {
+	if (!vpd || vpd->len <= 8) {
 		rcu_read_unlock();
 	        return;
 	}


