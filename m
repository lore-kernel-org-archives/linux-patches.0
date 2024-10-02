Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94031D0B8E;
	Wed,  2 Oct 2024 14:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877834; cv=none; b=borDmphzX+a15Xk8VUxtT4rMRW0OfJnRbcxlLal00/oOoutI2V2HyMRWRaCx5WgUEn12unJzdZOMa3HQ2KuZaSQiXkJrRu/jt3smZHgFYjF1HQAQFwUNTkYEhLqKioYPmlZOY53fH1tAKfKWdPRk8Cnxs4UcaUBbSvM/wCAqhNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877834; c=relaxed/simple;
	bh=8XGBvRM+/Gq7UKE2Ycm+D8rzWS1c+njYVPWX+LxQXSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gp/IUDbJ7JWGyUfFE5PNWimDLB2Dfos81L/2az/ePEXELKKXUjJ3HrEOZ/R+k+BlgLKrWH2O+Jp/yhGnzynaBJ6jz3IHTBDuRZSxtvpgbP4AQ/qITB105+1X59Y5rkyMvyGCZOSsSWbe7Xe8li//BjI16tpm3G4kvu37RdJgIm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILcrYELs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILcrYELs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C1FC4CEC2;
	Wed,  2 Oct 2024 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877834;
	bh=8XGBvRM+/Gq7UKE2Ycm+D8rzWS1c+njYVPWX+LxQXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILcrYELs19t1MWYimUxQ3mMrJIfh6tj0EK+0+SO/F5at4SaUOOCR6a3l/1eqh40Vt
	 73co8EzPM5caTAI26I+6rAs1Al+Ipq+2si7XAtU9lCQTdRmsJQveWAvSFg3vKnz8uu
	 2HxB/R+/Uo6z0yDpYARfT6Kc0i7P1FXDKNmEYCoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 211/634] platform/x86: ideapad-laptop: Make the scope_guard() clear of its scope
Date: Wed,  2 Oct 2024 14:55:11 +0200
Message-ID: <20241002125819.433123550@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a093cb667c3ff5eadd4b23ddf996d9ccae9b7ac6 ]

First of all, it's a bit counterintuitive to have something like

	int err;
	...
	scoped_guard(...)
		err = foo(...);
	if (err)
		return err;

Second, with a particular kernel configuration and compiler version in
one of such cases the objtool is not happy:

  ideapad-laptop.o: warning: objtool: .text.fan_mode_show: unexpected end of section

I'm not an expert on all this, but the theory is that compiler and
linker in this case can't understand that 'result' variable will be
always initialized as long as no error has been returned. Assigning
'result' to a dummy value helps with this. Note, that fixing the
scoped_guard() scope (as per above) does not make issue gone.

That said, assign dummy value and make the scope_guard() clear of its scope.
For the sake of consistency do it in the entire file.

Fixes: 7cc06e729460 ("platform/x86: ideapad-laptop: add a mutex to synchronize VPC commands")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408290219.BrPO8twi-lkp@intel.com/
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240829165105.1609180-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 48 +++++++++++++++------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 490815917adec..32293df50bb1c 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -422,13 +422,14 @@ static ssize_t camera_power_show(struct device *dev,
 				 char *buf)
 {
 	struct ideapad_private *priv = dev_get_drvdata(dev);
-	unsigned long result;
+	unsigned long result = 0;
 	int err;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = read_ec_data(priv->adev->handle, VPCCMD_R_CAMERA, &result);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	return sysfs_emit(buf, "%d\n", !!result);
 }
@@ -445,10 +446,11 @@ static ssize_t camera_power_store(struct device *dev,
 	if (err)
 		return err;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_CAMERA, state);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	return count;
 }
@@ -496,13 +498,14 @@ static ssize_t fan_mode_show(struct device *dev,
 			     char *buf)
 {
 	struct ideapad_private *priv = dev_get_drvdata(dev);
-	unsigned long result;
+	unsigned long result = 0;
 	int err;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = read_ec_data(priv->adev->handle, VPCCMD_R_FAN, &result);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	return sysfs_emit(buf, "%lu\n", result);
 }
@@ -522,10 +525,11 @@ static ssize_t fan_mode_store(struct device *dev,
 	if (state > 4 || state == 3)
 		return -EINVAL;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_FAN, state);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	return count;
 }
@@ -605,13 +609,14 @@ static ssize_t touchpad_show(struct device *dev,
 			     char *buf)
 {
 	struct ideapad_private *priv = dev_get_drvdata(dev);
-	unsigned long result;
+	unsigned long result = 0;
 	int err;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &result);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	priv->r_touchpad_val = result;
 
@@ -630,10 +635,11 @@ static ssize_t touchpad_store(struct device *dev,
 	if (err)
 		return err;
 
-	scoped_guard(mutex, &priv->vpc_mutex)
+	scoped_guard(mutex, &priv->vpc_mutex) {
 		err = write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, state);
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
 	priv->r_touchpad_val = state;
 
-- 
2.43.0



