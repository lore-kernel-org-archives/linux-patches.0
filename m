Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA611C6AB;
	Mon,  4 Mar 2024 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589366; cv=none; b=P+8SIxtTrels7OzSNhdTiIy8urROtYunUD0wJrvwWydm/uKeruJHnenu/dPpzHEOgWGErR4IrGp5c6X5dDy/f8d/k6zIzunzQs1+cZrpioPxGG4feUybjnM8EVa6djx4m9n8UEBFeYkOXgbBOXLzcMWfofpIZxcM1m4O4o4Lo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589366; c=relaxed/simple;
	bh=v/mbIKJwf10ARs8js+JtnrJ8DBHTqAKh6abD8oHK/e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHcgZ91ZnfCkqp5vmlsHLbUv6xEm250IsgmlxUOaTsBVKlZb8JKh4d/g/5+mSxVjWxFDB1GJt20Zm2xyFXQptseQHqoifVfhXwKcNZAYHKBslfTe6nThGzWCtcfdTvRw5ax/K42oKhQDNpqym7+dzoMfr/ix/1L2jFNVmPqJFS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+32+PA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+32+PA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CCAC433C7;
	Mon,  4 Mar 2024 21:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589365;
	bh=v/mbIKJwf10ARs8js+JtnrJ8DBHTqAKh6abD8oHK/e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+32+PA/SYF84Rcbo7JDZ7kiQkRiq2EtywOHRE/bsVRsO1KUfL8GwrIyNGV5GZnLb
	 VJdCu5A/os584mWp9o5V3isd2cS+s53YS0MWY5RUCwtmAzA+RxsQOjFwMFylb20Zv8
	 o1CkL7Ybj3bGs+52SPmAhBXatGeiFsxajAsvua9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 82/84] net: tls: fix async vs NIC crypto offload
Date: Mon,  4 Mar 2024 21:24:55 +0000
Message-ID: <20240304211545.149405041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit c706b2b5ed74d30436b85cbd8e63e969f6b5873a upstream.

When NIC takes care of crypto (or the record has already
been decrypted) we forget to update darg->async. ->async
is supposed to mean whether record is async capable on
input and whether record has been queued for async crypto
on output.

Reported-by: Gal Pressman <gal@nvidia.com>
Fixes: 3547a1f9d988 ("tls: rx: use async as an in-out argument")
Tested-by: Gal Pressman <gal@nvidia.com>
Link: https://lore.kernel.org/r/20220425233309.344858-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1568,6 +1568,7 @@ static int decrypt_skb_update(struct soc
 
 	if (tlm->decrypted) {
 		darg->zc = false;
+		darg->async = false;
 		return 0;
 	}
 
@@ -1578,6 +1579,7 @@ static int decrypt_skb_update(struct soc
 		if (err > 0) {
 			tlm->decrypted = 1;
 			darg->zc = false;
+			darg->async = false;
 			goto decrypt_done;
 		}
 	}


