Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5141DE3AA;
	Mon,  6 Jan 2025 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178072; cv=none; b=E70WU+gXKiMmZkQJ8PeyfLuX8NQigCWnmOCv9nWJh6puJwGTCv/iqEwuBlnbO05Snv0z59gltPuAFAixkye2+kHEDKJUbv/XqAo1reWACyt0//YKXy7dNB1V8vvpurxckh1U28anFai3pWH9bcgRSYjFHi2PwnCNilMMuWrCGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178072; c=relaxed/simple;
	bh=rmiQA0VS2Ot6tbpQlzsSrX2s6u6jGl2x523x895hlTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO0Ew8aItS/cpPM6TmuYoWzz0nXiYR9DnVtu7xlnKueCwekRSAE0CWBuTQ2wya2mILgXiYdW8Edk7FSV7eTBMOiV31/RbVsTXxRhOSVAEH0BUcs02HuiCXLBYUSwY3FOb2JusrjKv6CccLKy0We8QAnUfEFw39U2IVI6+cNX7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOkovQga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOkovQga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B153C4CED2;
	Mon,  6 Jan 2025 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178072;
	bh=rmiQA0VS2Ot6tbpQlzsSrX2s6u6jGl2x523x895hlTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOkovQgaEHxFCOkdL7Dky1iTSiFrCNntknCsDvAQHTikjmaz3AlUoSJsnzKc4Z4mQ
	 4ybRLlSEbTqN7Is8/p4C5NItvkNjiOZ9G7aDuripPgT6y7mngCViSUhZxeDxFZjBLI
	 RkOc8gbloCRpbKp6vx20SVChTGIwmQaf+G9M7qfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 121/156] maple_tree: reload mas before the second call for mas_empty_area
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151146.286667521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yang Erkun <yangerkun@huawei.com>

commit 1fd8bc7cd889bd73d07a83cb32d674ac68f99153 upstream.

Change the LONG_MAX in simple_offset_add to 1024, and do latter:

[root@fedora ~]# mkdir /tmp/dir
[root@fedora ~]# for i in {1..1024}; do touch /tmp/dir/$i; done
touch: cannot touch '/tmp/dir/1024': Device or resource busy
[root@fedora ~]# rm /tmp/dir/123
[root@fedora ~]# touch /tmp/dir/1024
[root@fedora ~]# rm /tmp/dir/100
[root@fedora ~]# touch /tmp/dir/1025
touch: cannot touch '/tmp/dir/1025': Device or resource busy

After we delete file 100, actually this is a empty entry, but the latter
create failed unexpected.

mas_alloc_cyclic has two chance to find empty entry.  First find the entry
with range range_lo and range_hi, if no empty entry exist, and range_lo >
min, retry find with range min and range_hi.  However, the first call
mas_empty_area may mark mas as EBUSY, and the second call for
mas_empty_area will return false directly.  Fix this by reload mas before
second call for mas_empty_area.

[Liam.Howlett@Oracle.com: fix mas_alloc_cyclic() second search]
  Link: https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
  Link: https://lkml.kernel.org/r/20241216190113.1226145-2-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20241214093005.72284-1-yangerkun@huaweicloud.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4367,6 +4367,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
+		mas_reset(mas);
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;


