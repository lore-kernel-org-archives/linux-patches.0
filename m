Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAD1482CA;
	Mon,  1 Apr 2024 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991350; cv=none; b=gLTSs+zDf0llAnU+KezvJgKLJ7Kgkasx9scD67l7lMq6CPizygvVrTjhvMin6ym3uYoAm4qxYX21+mBWFjxHoZakLQbPDdkmsqJMXFvrE2CqlNKGiJ8PmLuVXJ/GX3YvioTLEdBxpokq8sCMG1aTGKhsg+phc83DCBd/H7RniMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991350; c=relaxed/simple;
	bh=Q6VI6vABHdLZ97qypGph3jBepIDB+pVshWJXLeoCZMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSyJ5CvSks4VxZigDAONgN0LS48bw9h4hlDoj6mDcxH9Zs4UaKt3WqdkHy1iXvBHZDGdoPH8GjJIp9Fm1oA/ITiaVOySTfLdQA3asxaGCXbUSIntbat3cHu1oCzctUCbPt2QMei5b/5eLlQ6RVG5h3hqAI7AnGziT/cWVcjv0wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsfZ7xuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsfZ7xuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC92C433F1;
	Mon,  1 Apr 2024 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991350;
	bh=Q6VI6vABHdLZ97qypGph3jBepIDB+pVshWJXLeoCZMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsfZ7xuk0xjNIPmgWzLUUhk54Y/enshKk4lqRWxsu9aqhl4lN5q+PYcku+OJ6Bnmm
	 fHE1TmoqTFtNlqU9Qs1Twz5hz3yr2bQkA2JfcJBEIWRmvvlQ0HApmtXe6ZymyS2NND
	 CC5Kj9PpK1neU6H4k+MunhMtF3T5TO3whMEVlKfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.1 238/272] staging: vc04_services: changen strncpy() to strscpy_pad()
Date: Mon,  1 Apr 2024 17:47:08 +0200
Message-ID: <20240401152538.402203059@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -938,8 +938,8 @@ static int create_component(struct vchiq
 	/* build component create message */
 	m.h.type = MMAL_MSG_TYPE_COMPONENT_CREATE;
 	m.u.component_create.client_component = component->client_component;
-	strncpy(m.u.component_create.name, name,
-		sizeof(m.u.component_create.name));
+	strscpy_pad(m.u.component_create.name, name,
+		    sizeof(m.u.component_create.name));
 
 	ret = send_synchronous_mmal_msg(instance, &m,
 					sizeof(m.u.component_create),


