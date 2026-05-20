Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BB403EB2;
	Wed, 20 May 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303088; cv=none; b=NeMDbYXXeHL4XLVQCUf4/lfW0GExzNi79jHfVQQcmOlObZ24GCBn9zFL6i9p3gViS4+0Ox3uBsuviOknf1dzkf0v4NQ5l6ljEQ5wqlSaC6jsmTXAg5ZlO0ihaKWPFGXwMdke5/0nTDmPnPj0OTFH1A47zKzFP5Ty+7Js+7vfTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303088; c=relaxed/simple;
	bh=ISpo2iBKbxGblHKprRUpdTHkjMLHsPyOku3BVIluH7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miXS0Ci0m5RUzktGMtoIYHlSWRcUa438d4Ssdx8jhQrr8ejMfz1LeQaxkE52sxA8AlWLC5I/RS7Jtfqe3NplKNwHwuyfgiV2zfS22E7PKzrR4yAI7Tj93rxt0F+aLtNXy0ZZFVxqiBpL3P9xzZAYiPo5crOS78gqiWKeJ83s36o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arxdYzmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arxdYzmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF1C1F00893;
	Wed, 20 May 2026 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303085;
	bh=G0c18LOqf1WcdJw1X1TUBSc9WeXzwwOn2bxil5dvmqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arxdYzmE44s3kqYI2cKrCx9zyw6D5qK36fbS4X6Rjy7TSm3VoNVQEwPoQXLR6MHeg
	 hzpd1MCTCJRsYU+vbwRrxlfDnkgTB4MBlhwE7QOTNn3Tm1RSwiTlm0qoXWBs/xC/s1
	 6lpZARIrUwrOOfijI3P5mUM3u/NVP6OoyC1rvVP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 477/508] libceph: handle rbtree insertion error in decode_choose_args()
Date: Wed, 20 May 2026 18:25:00 +0200
Message-ID: <20260520162108.929061257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


