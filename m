Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25032E62B7;
	Tue, 17 Mar 2026 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766271; cv=none; b=ADVWjFyzn+egucJ3UWhUQK6cZPfGgvtbPzZS7htTiqXBARFsoJCNjQbjCIldbEJxpkH9Ai/+hqDO7EcBhncmyJggqJTW2Ml8qwYx2feTKbOr21GqEOo36ZQXb1GSmOAr4mV8RvpNCpqtm8WrlnsMhmna/5UaGSf6H2CrUj6MGjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766271; c=relaxed/simple;
	bh=Xz4vf4F5JXhVp0LIFqRqt0HstKD0uc4SYiNL5jdkch4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2vMWtVOivbyXE8VMYpuoamqRI33rrqaGUar1V3FxZ84jJTRZFxHJl9NUzHNTL7wfrZVGUKC5V/V1h3RJilUm/4HBQ9dddvSQmlmXAI/ypDhP7QAKfpy2ObdOvNT97ajN1KiQ/zY6GqF6FDFWqAKiux3I3ZE0NKDqhsKZb9FfLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BikIV+QK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BikIV+QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212F2C4CEF7;
	Tue, 17 Mar 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766271;
	bh=Xz4vf4F5JXhVp0LIFqRqt0HstKD0uc4SYiNL5jdkch4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BikIV+QKQ+l+iLMAnyh6/pBl9Z2MnPlV47HshMI/JZciVrhidSHxGBLpPz3Z4qw9C
	 1SggqEoyJ4QpbRf/0zN52/VIwlxaXUIOMoM5yt9zdRkaThm4r3am69fnziyFfnvQnl
	 l7eP+2tifkpXkO958CqD5GIwhmZjsOybIpuOp96o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.19 208/378] libceph: Use u32 for non-negative values in ceph_monmap_decode()
Date: Tue, 17 Mar 2026 17:32:45 +0100
Message-ID: <20260317163014.661452108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 770444611f047dbfd4517ec0bc1b179d40c2f346 upstream.

This patch fixes unnecessary implicit conversions that change signedness
of blob_len and num_mon in ceph_monmap_decode().
Currently blob_len and num_mon are (signed) int variables. They are used
to hold values that are always non-negative and get assigned in
ceph_decode_32_safe(), which is meant to assign u32 values. Both
variables are subsequently used as unsigned values, and the value of
num_mon is further assigned to monmap->num_mon, which is of type u32.
Therefore, both variables should be of type u32. This is especially
relevant for num_mon. If the value read from the incoming message is
very large, it is interpreted as a negative value, and the check for
num_mon > CEPH_MAX_MON does not catch it. This leads to the attempt to
allocate a very large chunk of memory for monmap, which will most likely
fail. In this case, an unnecessary attempt to allocate memory is
performed, and -ENOMEM is returned instead of -EINVAL.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -72,8 +72,8 @@ static struct ceph_monmap *ceph_monmap_d
 	struct ceph_monmap *monmap = NULL;
 	struct ceph_fsid fsid;
 	u32 struct_len;
-	int blob_len;
-	int num_mon;
+	u32 blob_len;
+	u32 num_mon;
 	u8 struct_v;
 	u32 epoch;
 	int ret;
@@ -112,7 +112,7 @@ static struct ceph_monmap *ceph_monmap_d
 	}
 	ceph_decode_32_safe(p, end, num_mon, e_inval);
 
-	dout("%s fsid %pU epoch %u num_mon %d\n", __func__, &fsid, epoch,
+	dout("%s fsid %pU epoch %u num_mon %u\n", __func__, &fsid, epoch,
 	     num_mon);
 	if (num_mon > CEPH_MAX_MON)
 		goto e_inval;


