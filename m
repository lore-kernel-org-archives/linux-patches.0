Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD18C1E895;
	Mon,  1 Apr 2024 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989139; cv=none; b=XQf28JYFbCi1uGZwLq0YI5SulOMHpNfMAK1ef+Qqe/OA+VOF+s/m74wVsbgQruC8ESXQH48xCfr5ZBLzvZq12AlrUjTHnFHNLEwGNqr3lYWWFuqSF/sAQTiYBbaU+eaomu2wBNJDlRRKVhbrcQOsTLzo0OdwJGMuT27AZy5D6m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989139; c=relaxed/simple;
	bh=5CrumbGoi6ngIPjXcBS0KPJrbX9pxh9TWUmh5qFPAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NH1DDDSiksap1kMnp7rHo5uIknB5RLmYvCiiPiABoGdCQZirBPpWsK2LAryPN9Mgez9cy0OqiUB4Kiul6TOsuKjJ97Wcb6sRe2xZt9R5Op1bZNTlIriUi9ExvjOqyDq++bl09dXFFpDxkNMQVryIN0BqWjkDMYK5QriOvaYv0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpOOGhfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpOOGhfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE37C433F1;
	Mon,  1 Apr 2024 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989138;
	bh=5CrumbGoi6ngIPjXcBS0KPJrbX9pxh9TWUmh5qFPAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpOOGhfji44oEQXYjyzi2F4twme0twogviOogPICfFL8UL15vlqOoC24K2A2GPPaf
	 uFudmI2N2SmZRT2L8tqpO9fv3pIfBDA4H5wdXNHDIktSzI3XrQX8eYd7U8XB1/IsNL
	 5Q1hadmL1f2LRn27W08DzZYwL+hHWfK56QYnLW10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.7 393/432] staging: vc04_services: changen strncpy() to strscpy_pad()
Date: Mon,  1 Apr 2024 17:46:20 +0200
Message-ID: <20240401152605.065038554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit ef25725b7f8aaffd7756974d3246ec44fae0a5cf upstream.

gcc-14 warns about this strncpy() that results in a non-terminated
string for an overflow:

In file included from include/linux/string.h:369,
                 from drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c:20:
In function 'strncpy',
    inlined from 'create_component' at drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c:940:2:
include/linux/fortify-string.h:108:33: error: '__builtin_strncpy' specified bound 128 equals destination size [-Werror=stringop-truncation]

Change it to strscpy_pad(), which produces a properly terminated and
zero-padded string.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240313163712.224585-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
@@ -937,8 +937,8 @@ static int create_component(struct vchiq
 	/* build component create message */
 	m.h.type = MMAL_MSG_TYPE_COMPONENT_CREATE;
 	m.u.component_create.client_component = component->client_component;
-	strncpy(m.u.component_create.name, name,
-		sizeof(m.u.component_create.name));
+	strscpy_pad(m.u.component_create.name, name,
+		    sizeof(m.u.component_create.name));
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


