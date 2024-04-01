Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CBA40876;
	Mon,  1 Apr 2024 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990461; cv=none; b=Ev3grevclTNuPUwvaLLCbAlA346K9HpRT5fYTN1MdeESNEBT89Rzge9dB+rNBDidugfQdx3HWsILIEGxZq3YzmjzKYpQiMl0ZEMnFFOUzB1yJuNXemlTWvNfDTPDF0ywZNT6Ff6+l9cswAMU/SFGgnavfLE/Lspnn/nj/mIcJ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990461; c=relaxed/simple;
	bh=titBK7qWzKOgSnc3ileeSI0iwHwREh4VMfFhY0SQt7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feBaNkCr9eqnGyLuRmDpHJCc9RAgkYeSuwwn+WwcO5MZm/X9WkuP/itOpf2GZfdLIaFxxgz9U/Q+h1bxmN22CCe5mVDOokeWbS8hSAVSBn4IPTVN3DL33SCzfgDUf9a+sUBO8jwPJsiR8KX/D7FL6S6XYZ9M2RXjhLl70INbce4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO+wvUKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO+wvUKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C944C433C7;
	Mon,  1 Apr 2024 16:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990461;
	bh=titBK7qWzKOgSnc3ileeSI0iwHwREh4VMfFhY0SQt7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO+wvUKWKs+LpBGyhnLZbST0BJhgwy7R8m1/t1/q+pgtIm0MqKLVr4gln8exFsE2M
	 pNEU151NReyW7UnvQEJx9bo3fFG2caWRnLmYAUjD5oraPBVqtnK+YXHkRMQXW/fj7O
	 WvbR97KwjeT3AKWdP0Ae+9183m6x/7q1d8K8C0Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.6 360/396] staging: vc04_services: changen strncpy() to strscpy_pad()
Date: Mon,  1 Apr 2024 17:46:49 +0200
Message-ID: <20240401152558.654744412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


