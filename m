Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF3E7BB15;
	Mon,  8 Apr 2024 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584955; cv=none; b=qjxgw/9i/MT/H2oBBL5BdtWbzXPLUfa3ICu1Xzq0wLrw6qrQQAFBF00VOm4bBTosnpoA+sAKS9w5Cfcuzd1bJZ5Wze3xg2zFyKdWRqHgX6DtJ6Sm7qeblQ8gyL26ujVlvgis3mOsNl5CveqIwRrqqOp9DrkgPnCXxkhuBkVtpKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584955; c=relaxed/simple;
	bh=B7TIeqhwIfSDnzoEd1HcQm6q6wMfr7CROY1oLh0Nl0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4ya7k29gWSBbaYyPr6ShvMslebiouthJLKQ7JG6JBQSHMiXYlVUxaN0MPUxcZ+bsBVUazQFKi9hHwYGdzikoxdhs6rZbhOGkITB9PudqlaYLj0ZT22ElsUO3ljfxEAeylW29dLuFscJfdTT3lQWmzQwaOZM0bvneZxbDyy/564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMB+thfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMB+thfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C8DC433F1;
	Mon,  8 Apr 2024 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584955;
	bh=B7TIeqhwIfSDnzoEd1HcQm6q6wMfr7CROY1oLh0Nl0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMB+thfi0iyzInoYYTQ3Id+xR8K5y7EF2ovWw4xAmbeA9JXesnjyLWwacIPO0Ishb
	 9WNJg7edMf9Ai5CzkwwdvF1JB4Z94DRHxuIC0DAUEdtGZ7vUJE12jRMA3IaToEjF/C
	 nn8dhWbu+gfya/fBSbPxhdFVSRI83wfAxOJpmhdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.15 583/690] staging: vc04_services: changen strncpy() to strscpy_pad()
Date: Mon,  8 Apr 2024 14:57:29 +0200
Message-ID: <20240408125420.702883173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -940,8 +940,8 @@ static int create_component(struct vchiq
 	/* build component create message */
 	m.h.type = MMAL_MSG_TYPE_COMPONENT_CREATE;
 	m.u.component_create.client_component = component->client_component;
-	strncpy(m.u.component_create.name, name,
-		sizeof(m.u.component_create.name));
+	strscpy_pad(m.u.component_create.name, name,
+		    sizeof(m.u.component_create.name));
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


