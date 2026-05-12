Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316143EDE61;
	Tue, 12 May 2026 18:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609167; cv=none; b=BSDmfv0YS4bhnoPUek+XxbS+jG2LH47+rmcPYI4vzHVSbAnTCVYbUWJ6XfB30G4+nlCan6aWNsb9Ku+TxR/pddzxWI8VgsXDejTfy03f21FffY+AvCLBumDxE87WtOzS2DpQoRyfVHyYAXbj9Z+DmAfWn25JV1o2v8VWzZeqQ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609167; c=relaxed/simple;
	bh=SO9o8OftRVVqTJWM5/j4AjsDwaMZHhToYJ6x4Uw3onQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYRCWrx3cGpSDIx3pBwkKMKo60p7oqnEnqPBumvYPvLrmL79VZmcJzeSgStcZFrMGsBa2IGvzubhxPAqd+xQURzwGcma8IBjsYBOxtDUmlfGsx87Lg7S6n13t9aXoWS3KLGGocS32HoXGnGPc1z8WCWzwtCHi3LnKWS+951HumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klvcbjE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klvcbjE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD47CC2BCB0;
	Tue, 12 May 2026 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609167;
	bh=SO9o8OftRVVqTJWM5/j4AjsDwaMZHhToYJ6x4Uw3onQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klvcbjE0JpIaHyKnB1EDeWqzwVQfEs7H5frH0je9fT9Iy7eyH3NDO1llIAcnl6H97
	 dOM468Xoq0e4XL+sm+ZLuowAlv6wfE6HqX0RYefF/IopuDoRGKLYegSkUM0WML7HOY
	 d7rdfsTIc/YLdyr1NS7RuIRCTpstU0EEWm/2cvDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn@welchs.me.uk>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 091/307] staging: vme_user: fix root device leak on init failure
Date: Tue, 12 May 2026 19:38:06 +0200
Message-ID: <20260512173942.049423038@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1230,6 +1230,8 @@ err_master:
 err_driver:
 	kfree(fake_bridge);
 err_struct:
+	root_device_unregister(vme_root);
+
 	return retval;
 }
 


