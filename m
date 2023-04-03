Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B746FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30805C4339B;
	Mon,  3 Apr 2023 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532860;
	bh=5ksT/VopG9E0WBigQofaC8e3hEBi4gPeNc2vegbD6RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5Hweujly5gAK90r/rmUL+3/inPkM413a9zbgVdzb5hwwgI9HJHOvCEwVD+YXmplP
	 Qs5ygn7wDfvN3NRxuWvRpuxH5tPXhxFlCF+KAjVf7RVEQg+jHy9mwS6tXp8W4P4oXz
	 +ZYvjHckNvez56bl7VYxnmuolpIQIOlhHtqEy2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 144/181] modpost: Fix processing of CRCs on 32-bit build machines
Date: Mon,  3 Apr 2023 16:09:39 +0200
Message-Id: <20230403140419.744797431@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <ben@decadent.org.uk>

commit fb27e70f6e408dee5d22b083e7a38a59e6118253 upstream.

modpost now reads CRCs from .*.cmd files, parsing them using strtol().
This is inconsistent with its parsing of Module.symvers and with their
definition as *unsigned* 32-bit values.

strtol() clamps values to [LONG_MIN, LONG_MAX], and when building on a
32-bit system this changes all CRCs >= 0x80000000 to be 0x7fffffff.

Change extract_crcs_for_object() to use strtoul() instead.

Cc: stable@vger.kernel.org
Fixes: f292d875d0dc ("modpost: extract symbol versions from *.cmd files")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1722,7 +1722,7 @@ static void extract_crcs_for_object(cons
 		if (!isdigit(*p))
 			continue;	/* skip this line */
 
-		crc = strtol(p, &p, 0);
+		crc = strtoul(p, &p, 0);
 		if (*p != '\n')
 			continue;	/* skip this line */
 


