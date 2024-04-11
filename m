Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7DE146D61;
	Thu, 11 Apr 2024 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831904; cv=none; b=XGQEUn8hp5t5cMsbv9rztT1aJ6vsGr5MuBHmi5cODSIj8yFoH8Z7Ql7Zs1dc30mC/oznKlcuYbRnuDXSQUyc/NXt7rqRgfroSPOC/VzqNlQDewv5JjOUdsz7FR6ccEcOUsSGSF6fcjqV+moCmmYXmVJiaurBFkZV+4EbWCFfBH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831904; c=relaxed/simple;
	bh=nbsSNUmY5ejFM4mSD/lRKE2FQG7T1Grq0xOxLNUAmF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmW9S+NCCk2iC/TIObQBTEEMUX558zOwGVt74GLhr38F1TvQyEC0QsfCuCg8t0+fUKyqNM8OV+mV/huenOqwcE6u/ERepEmf/h0Yylp6Dd+mql3VIG1cBQ/SNdcURtBRhzZhLRG3RSc2GiMwFT4fv0i310KGu/V2euWUmyyIbGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFghZvBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFghZvBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889EBC433C7;
	Thu, 11 Apr 2024 10:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831903;
	bh=nbsSNUmY5ejFM4mSD/lRKE2FQG7T1Grq0xOxLNUAmF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFghZvBT5QXsyjf3t3PXzqnibgNy+RZYPcNGzfRpyoX5wNbC+p8s3LB768PsDLuoO
	 ZgADitectPgUoU2PCLrLHaAqaoNfahsi6yU3QPAGfTunAocXjmQJ8sFztwM7tDTgqb
	 MBJJz72s44Dc9EeSFLRQE2CvyGSmHoDz12ZxWju4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.10 165/294] staging: vc04_services: changen strncpy() to strscpy_pad()
Date: Thu, 11 Apr 2024 11:55:28 +0200
Message-ID: <20240411095440.608510250@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


