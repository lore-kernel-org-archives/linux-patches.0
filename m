Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0949F332EBD;
	Wed, 20 May 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301664; cv=none; b=f3c4lN3+eDpOxnKFm+hSnNy2GUY1KlSdCTWVNg88eilrUQlkSW+N2BV8rCbgplMiOthWpLmgkScrRH/b0HDf82/guTjAiTd3tD3sv5/TOJp38HuEb0zvspLjqBICp5UmptdGvkk3HFidCvSUbqJtia/FEA3RXe3iYWGD/kH1Pc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301664; c=relaxed/simple;
	bh=iGSFB9o8k8B8uJxeNQ2GgdzfclFmLw0aNFeqzrCWPFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyHoIfPgPHy2xCUqPB5oEf3Lfli4V8W23zfgAAl4ddQ/p+3wgIu7q9E5fB60m7QrKy2oDtZryphbLsI2Q/VuWBnAMSW6kF6PzpKvqO7F0sD/sumAMugVbrQBt2pw2Gbo4jx+OVzRkazNLRBjaP/uIOzwI1IdWcPUqOAmhRRMQ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLD8+tfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLD8+tfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDE71F00893;
	Wed, 20 May 2026 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301662;
	bh=snskpQW4/OQIFsqELVjWyFucQpBmSwWpNjVCiXQcROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLD8+tfDz2M9PyTGAaQSBKL1xwPLaeU84XgHvfWG3hsHQdHw1r7GzLluuDzOOXAw8
	 52cNFs1Jfib+XWb7z2cEJ0WiZtwEi6DL0Mtj9HrFHN8mT1bvvRZMOlGx0k5e5lO8xg
	 Blfc9Bzx1SNsNzkG3PStiECYZtSoYHV4HxmpVW/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 639/666] libceph: handle rbtree insertion error in decode_choose_args()
Date: Wed, 20 May 2026 18:24:10 +0200
Message-ID: <20260520162125.126710506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -395,7 +395,10 @@ static int decode_choose_args(void **p,
 				goto e_inval;
 		}
 
-		insert_choose_arg_map(&c->choose_args, arg_map);
+		if (!__insert_choose_arg_map(&c->choose_args, arg_map)) {
+			ret = -EEXIST;
+			goto fail;
+		}
 	}
 
 	return 0;


