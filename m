Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E533451AB;
	Fri,  4 Sep 2026 06:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501673; cv=none; b=cCx7E2rwloxCzX+heuHZEioYhG1ESFdl0XG4ptXjEKMWRMRbmHJrcm0xXBxF4rpXjFqvJEcv8eoh2pIAO21mY/VeMrhSVSq4C39H1mJgOofRBnUPj/kgVv7Vg6iSmHgKZIf3QwUdhOP/ehDElRPRVTO3c1OVvb8EbZAW3nbcpYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501673; c=relaxed/simple;
	bh=6pJO+wysRKrER+CkE9P3NxL/fknU1tth0P4qM88vlzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2Y0XaZbfz81PrGq4hyob5L2DtIeIo9d5KTe1zdYTWnj23GeF51Ci1aepzBZymO6ZV9ImRE8teLIYOWUyhGCILXxiVT38aDRpJOv7n/mJbggKo7E3RB1s2dlhUzdOI3OH8GmI0q7iW8zhfYEuepOmUNV5LhrZK6pms4r7jF7dMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7arxcjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7arxcjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2025B1F00A3D;
	Fri,  4 Sep 2026 06:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501672;
	bh=ObLlDsUiNSbBNY41yJQrAKb321JySra29cwrzpUp14M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7arxcjNewprcuoLXuZP1T5eATeHRcyP5w+sTwx7pmPBWaHzXNaoW1Lxds3lTqcB+
	 u9au88+jWLdAJ9rmLk6RVjXyDv4zvS6rNhE4+IW8f98ajiOghQAsKbN7rmsImUw/WL
	 ZHrP0CGGR2lqFd8rO1as0NTYdAjqTmAwT2mUSRJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 439/552] platform/x86: hp-bioscfg: fix new_password_store() overwriting current_password
Date: Fri,  4 Sep 2026 06:59:56 +0200
Message-ID: <20260904045800.544163533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,7 +123,7 @@ static ssize_t new_password_store(struct
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
-	return store_password_instance(kobj, buf, count, true);
+	return store_password_instance(kobj, buf, count, false);
 }
 
 static struct kobj_attribute password_new_password = __ATTR_WO(new_password);


