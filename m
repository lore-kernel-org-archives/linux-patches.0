Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90B21B5823;
	Tue,  2 Jul 2024 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941427; cv=none; b=lfY7ecmESnSuNDTLoOPjaKU/E6xUghkYYR8meZUPhAiEn7ibChM5nwefU9vRcYNb5xaFiE0SltQZ6gvBz9cvBa0diXj/IXtXnbtdFmJKwkFr0aRt2dFPS8WbZrl/liIpy5OMOBx49Ll2vU+I6cKckyX7oGwcm7wfzLFr4Rh7fYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941427; c=relaxed/simple;
	bh=1pJX3PQCIWIq0Kxaq025YEr9uoVxI1tEkdB/QVMXYnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pivmCXYxs6ERvwQUZuz6Gr2VN062G+E2IL2nySDF6dBLo/HL1/EuzrR3JmoSTZ//mRQVj831orvWzhSsWA4t4siw+NMQAmcJe0YuoLCmXqTTXoyswtm5gSl1icOXE/fCF3E1PGwzJJrRP2pWnhBCvsKlNGCy6HXin02M7eQcqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6lzSo/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6lzSo/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C61C116B1;
	Tue,  2 Jul 2024 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941427;
	bh=1pJX3PQCIWIq0Kxaq025YEr9uoVxI1tEkdB/QVMXYnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6lzSo/F+tzY2gdW3yxbua5sOKfc+oJnozRB0PO7RJ600YEn6PYwXyCZqjA2H99Ow
	 UdrcRGsK7LUtUGsnUhVlXdHWvrJ6NkNJ5NJeUwCtuuiUTfEIuPh5kVADE4pRAjSZEz
	 Crwjw6CKbFwWYQsXCnTIOPjOotA55bGtjNYbuZ1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/128] gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)
Date: Tue,  2 Jul 2024 19:04:20 +0200
Message-ID: <20240702170228.463332333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit 9919cce62f68e6ab68dc2a975b5dc670f8ca7d40 ]

linehandle_set_config() behaves badly when direction is not set.
The configuration validation is borrowed from linehandle_create(), where,
to verify the intent of the user, the direction must be set to in order
to effect a change to the electrical configuration of a line. But, when
applied to reconfiguration, that validation does not allow for the unset
direction case, making it possible to clear flags set previously without
specifying the line direction.

Adding to the inconsistency, those changes are not immediately applied by
linehandle_set_config(), but will take effect when the line value is next
get or set.

For example, by requesting a configuration with no flags set, an output
line with GPIOHANDLE_REQUEST_ACTIVE_LOW and GPIOHANDLE_REQUEST_OPEN_DRAIN
requested could have those flags cleared, inverting the sense of the line
and changing the line drive to push-pull on the next line value set.

Ensure the intent of the user by disallowing configurations which do not
have direction set, returning an error to userspace to indicate that the
configuration is invalid.

And, for clarity, use lflags, a local copy of gcnf.flags, throughout when
dealing with the requested flags, rather than a mixture of both.

Fixes: e588bb1eae31 ("gpio: add new SET_CONFIG ioctl() to gpio chardev")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://lore.kernel.org/r/20240626052925.174272-2-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 97e8335716b01..be51bd00d2fd2 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -132,6 +132,10 @@ struct linehandle_state {
 	GPIOHANDLE_REQUEST_OPEN_DRAIN | \
 	GPIOHANDLE_REQUEST_OPEN_SOURCE)
 
+#define GPIOHANDLE_REQUEST_DIRECTION_FLAGS \
+	(GPIOHANDLE_REQUEST_INPUT | \
+	 GPIOHANDLE_REQUEST_OUTPUT)
+
 static int linehandle_validate_flags(u32 flags)
 {
 	/* Return an error if an unknown flag is set */
@@ -212,21 +216,21 @@ static long linehandle_set_config(struct linehandle_state *lh,
 	if (ret)
 		return ret;
 
+	/* Lines must be reconfigured explicitly as input or output. */
+	if (!(lflags & GPIOHANDLE_REQUEST_DIRECTION_FLAGS))
+		return -EINVAL;
+
 	for (i = 0; i < lh->num_descs; i++) {
 		desc = lh->descs[i];
-		linehandle_flags_to_desc_flags(gcnf.flags, &desc->flags);
+		linehandle_flags_to_desc_flags(lflags, &desc->flags);
 
-		/*
-		 * Lines have to be requested explicitly for input
-		 * or output, else the line will be treated "as is".
-		 */
 		if (lflags & GPIOHANDLE_REQUEST_OUTPUT) {
 			int val = !!gcnf.default_values[i];
 
 			ret = gpiod_direction_output(desc, val);
 			if (ret)
 				return ret;
-		} else if (lflags & GPIOHANDLE_REQUEST_INPUT) {
+		} else {
 			ret = gpiod_direction_input(desc);
 			if (ret)
 				return ret;
-- 
2.43.0



