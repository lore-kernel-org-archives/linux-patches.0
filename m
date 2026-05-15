Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDBC3E7BC4;
	Fri, 15 May 2026 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861141; cv=none; b=hElUf+52ArnxA8QwQVjxxm7QfwnpR5EbhX7UV7joPmM1wL3HJFOCRT7U62V5YFalIB/L4wuvMKlPvneoUumcW26ZnKbJEeQPiZ/mB8fKDQ3EGYtBi4Pb+y9zhfu0JG49rFS19arwwxg/8ogha292jxJ3/jAEOZtEVFZIfKho4Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861141; c=relaxed/simple;
	bh=0s2oxgWr2/GEPHYb2hty/z3hbphPV0ryl3nMEFFgC+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNm4OWDBEo0+9Z/YKCYviHw737oAPpD2/HEFhjYyZFcmidw+8WOQZ+TGKWEdtD8qZbtD+zNa3tcpeB4V8JF8ym4O2RdQ4il8C1JJAndHIqi4RHHDmdZRiD0RjUB8rK1s0GmuHFTIVfGU/oq9edIFyOO0MmmCL96SuhFdD7cZAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKdOfc4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKdOfc4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7D4C2BCB0;
	Fri, 15 May 2026 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861140;
	bh=0s2oxgWr2/GEPHYb2hty/z3hbphPV0ryl3nMEFFgC+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKdOfc4VHS/KewRdT1cqKVp2aAg7PtiFA2mFJ1zDXGmtc9E7SZTxv1au9VTfRLHS7
	 5PdKj9FEyq/7gIB529CdL08CAXGiyk6PNgeBah09DL3VyqPM1zY8BZpqVklsFAyFm3
	 JSn21qec26I2xui1LiG/IBle7IFv8TG9QyXtZUf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn@welchs.me.uk>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 215/474] staging: vme_user: fix root device leak on init failure
Date: Fri, 15 May 2026 17:45:24 +0200
Message-ID: <20260515154719.662135934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

commit 32c91e8ee039777d0b95b914633fc6a42607959c upstream.

Make sure to deregister and free the root device in case module
initialisation fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Martyn Welch <martyn@welchs.me.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260424104910.2619349-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_fake.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/vme_user/vme_fake.c
+++ b/drivers/staging/vme_user/vme_fake.c
@@ -1235,6 +1235,8 @@ err_master:
 err_driver:
 	kfree(fake_bridge);
 err_struct:
+	root_device_unregister(vme_root);
+
 	return retval;
 }
 


