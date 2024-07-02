Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2918715218A;
	Tue,  2 Jul 2024 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941029; cv=none; b=CoakJKfdaZ/FWVEqzpYnzGm2HxDRX3lBHucPIcaBUJAhGYRJ//8I+fLRDZ2ZCw/AuqjtPjNWDgbkUWbjEr4HWnxlEpSDAfU4pIQ8R/06vFBru4OZXK8vf16dKFs593lw3EaPrbMQL2pCDGZwALJEMk9tXawtU8Ld2+n9B+waDZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941029; c=relaxed/simple;
	bh=Jchn9EHC0amnzOIuw/6LW+kiFHn0C3jySeDFJjAXqhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/Kr4YX4YXe8bfb+N7EgeKLOc1aF7OWxRbQ2zzJFjjjef6zNYhW6jrZ6ixK4cSNjNZXbByoAckRoAzSi4yWjz+DyZDtS8jT9SZwGW34FAOphLCnbla1re6X2A2kouMMXr2+yYuI1+6r0X9pH7FDqDCnFKRPRJKepgLFROFqAs+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbw7udx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbw7udx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C65C116B1;
	Tue,  2 Jul 2024 17:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941029;
	bh=Jchn9EHC0amnzOIuw/6LW+kiFHn0C3jySeDFJjAXqhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbw7udx6mvGFu8cyr/Za/NaPk5E/KfSDwdcZZ+GQmWjtcuJmEOvtHl9QLPuYC8ON5
	 JVbaTUPDIl9ONRplLfOpPZ1iSLuMKQacI4y8UT1P/XmXd+ZTJ26dhyQU5tCr/HK1P5
	 elLpj3yJnmmZ+eDsPnkvgJzR62sFbFn0sqv2JeJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/163] gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)
Date: Tue,  2 Jul 2024 19:03:10 +0200
Message-ID: <20240702170235.940645512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b4b71e68b90de..d526a4c91e82e 100644
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



