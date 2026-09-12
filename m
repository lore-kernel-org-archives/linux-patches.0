Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5EC2FDC30;
	Sat, 12 Sep 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220773; cv=none; b=Xu4UGz8+SIUUnkMhzcVPA0LIMATUBp+W3vPXU3cz+Ds9cGOcYZF5/ewZtpxaybf7Qnn44f+xAlnI0OqxtkFXS7ByUoUX98KNT8XcXci5mQogmKZUjg1POc+abdtmdg85pqblCOW1NqD2RtXCssqFQpoVCVkmjbHuwmQMokox8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220773; c=relaxed/simple;
	bh=b/TMZTAstwepcrtLa92Qmjfdfg/rEIvni5cnqjwd67E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0CMf5Fh2jIy4t65tdsl4T4fKEVOUtA2UCSxcoVrRqKqr4vVY+5vpUoCvBVa6kfNk+Cx0kL24Jsumh4WUrVfOywy9/8YWjrFkEkyKn6pqsXqn7Py2PfolJnQEZRZVurIKk15AXz9OS5AohZ8kOvVoIz9un62nkIs6T0jSCTxPy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9sqREIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9sqREIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93F1F000FF;
	Sat, 12 Sep 2026 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220772;
	bh=wy0/h3Yf17VV/slAAroBncDs5MOz61oBhXwi1KQ1KaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9sqREIa3wMBjtP3z6oJv6Fd7x7LUGnsWBcIBUkbADS1boMymXs/MStyEc1dp8N/O
	 Uw+xgx86O1aZ6MPSE+C1hWQvYWEaAkIXN/Td/Cl2URuNqLRZEpLQsSv02dfeA3zlu3
	 q2dYeRzk9LC4Y/przr9RAtkGANwTmfEEn404H410=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0245/1424] platform/x86: hp-bioscfg: fix new_password_store() overwriting current_password
Date: Sat, 12 Sep 2026 08:44:37 +0200
Message-ID: <20260912065612.767931793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit 2ea12a467a9cb12170417b30784fe26a243a75fe upstream.

current_password_store() and new_password_store() both call
store_password_instance() with is_current = true:

	static ssize_t new_password_store(...)
	{
		return store_password_instance(kobj, buf, count, true);
	}

so a write to new_password is routed to current_password instead, and
the new_password field is never written by either sysfs entry point.

Fix by passing false from new_password_store(), matching what the
is_current parameter is meant to select.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-8-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -128,7 +128,7 @@ static ssize_t new_password_store(struct
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
-	return store_password_instance(kobj, buf, count, true);
+	return store_password_instance(kobj, buf, count, false);
 }
 
 static struct kobj_attribute password_new_password = __ATTR_WO(new_password);


