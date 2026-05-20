Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE336826B;
	Wed, 20 May 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299940; cv=none; b=PJi0mDkT8RoMy3Vz2uoUFyYcZnAToLhQqz2ceJr9ulVa9tRxEzNCVZHo4BHw/e0EG6R4WO00L6XNGM8kv6qHqhjsnWReM4n6G5SLKcu+OC7FyHi84MH6kt7BOuy3sNXdPpFyXEARlhuFBEAIxR3tJu0tc4jWLsE5vNbkqRQ0SeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299940; c=relaxed/simple;
	bh=8IaLtBiMB6ZuK94MOZMXfAO4DDZjMfDazyw1VfkMUIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6KrvIVccGs6nNQtJZxgm7tLItuUS8N9TH7WBwelr7Wl2Pv76UBoFeFILtY57LVji8HkAJgrELD0USHaWg1jxNmY4ngQrwulGyFHXyIGLbFGEpFH5bIt1teQ/snfUTL76dZi4AsJyzQAXiQcvuKyJxLN83i4xoUoXrYGpBoBuho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpQAl4pD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpQAl4pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58691F000E9;
	Wed, 20 May 2026 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299939;
	bh=jKxNWZthcTQJHkBsDGw0Bd106Hb0OT94rGQmKyVGcIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpQAl4pDzymb7Vh36weTd9stYV2itLKoFlaVcItcVjZnBPxLU1eAoCCeI40xF5RbZ
	 6iNiKzuTfB4T43bdMC9bjHtL26l1tilKJUkR5u2BfLoQ0B5eBB23af121N+hXl3m30
	 VowkmsyMubyWoTD2Q6q0GXD6x8UlI8AHgvHnygh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.18 945/957] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Wed, 20 May 2026 18:23:48 +0200
Message-ID: <20260520162155.094227289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 950953f774b3f69da6f413e045ef075e1f3da2df upstream.

Make sure to drop the reference taken to the I2C adapter (and its
module) when setting up HDMI to allow the adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -579,6 +579,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


