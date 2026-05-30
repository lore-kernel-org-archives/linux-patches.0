Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242C4175A6B;
	Sat, 30 May 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164795; cv=none; b=sg1H/VfKI+KFtiEm8U7uzgsykBFUzg2U4IQ8cv2u7EdOfYndA7RNHPyUhN2Yor49fa5p179+CEYSK3rzJuD03K5iw6oEv7BAwFrHiQxtZn3aZXNVCm1EckXLn3eUCYkUSBeCxgLES40WmRla5KvDCi4NZabBRvbJWfZdWVN+aPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164795; c=relaxed/simple;
	bh=zrc4gk+BMiUmeqZMJsW6mdfTgQMtzvdMjabxS/RFe70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dy3z8He8xNXR7i4vwHexgfpRb9h1sJccqoz43AAl6QN4wzLfA9Pg1CIgT2V6T2LcX8wqZ8kIBOXdixjCRtYQ+6lEZ4EI4kATC/EqwjTZBqB8/J88DoiuVbTC4uHH+Znvr2rfzH0dzDqnXN7pp6JXRbXEhW/PaB/CpqIIfXyL+zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIvKRpzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIvKRpzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6527D1F00893;
	Sat, 30 May 2026 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164794;
	bh=KHrZy4b8r0enUnxJdnuO/DHM+DA7JPbNsqgzyeB1zL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIvKRpzHFKE+EaMuNhUyKqYjduZ1Zgd8g2eZNSVndX/MhxWH1+nQjCequ1jOzw0In
	 KZ9ZgSgvj5xoOFxNFu9/QMx+cu/Mtjb1WPgGHYGPorEwoI6Ia2IXWFPDfi9KqSrGks
	 ReKCmkSe6ws5dgfl4rdJCt354Amarx/uKlM78qD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 662/776] libceph: handle rbtree insertion error in decode_choose_args()
Date: Sat, 30 May 2026 18:06:16 +0200
Message-ID: <20260530160257.003729636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit d289478cfc0bcf81c7914200d6abdcb78bd04ded upstream.

A message of type CEPH_MSG_OSD_MAP contains an OSD map that itself
contains a CRUSH map. The received CRUSH map may optionally contain
choose_args that get decoded in decode_choose_args(). In this function,
num_choose_arg_maps is read from the message, and a corresponding number
of crush_choose_arg_maps gets decoded afterwards. Each
crush_choose_arg_map has a choose_args_index, which serves as the key
when inserting it into the choose_args rbtree of the decoded crush_map.
If a (potentially corrupted) message contains two crush_choose_arg_maps
with the same index, the assertion in insert_choose_arg_map() triggers a
kernel BUG when trying to insert the second crush_choose_arg_map.

This patch fixes the issue by switching to the non-asserting rbtree
insertion function and rejecting the message if the insertion fails.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -379,7 +379,10 @@ static int decode_choose_args(void **p,
 				goto e_inval;
 		}
 
-		insert_choose_arg_map(&c->choose_args, arg_map);
+		if (!__insert_choose_arg_map(&c->choose_args, arg_map)) {
+			ret = -EEXIST;
+			goto fail;
+		}
 	}
 
 	return 0;


