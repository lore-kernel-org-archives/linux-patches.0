Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07E928505E;
	Mon, 13 Apr 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097486; cv=none; b=Hz+e9mB+twy2R+mYdexDTSUCGdM4+LJGAj9HvqVg8/Zp4dpjZHt8+X2CNZjX/Zm1G3XLvBVOPsJY6nnRpPeZROXsIYcQlAJnIxPcT3iNeioAsHuJw/56j4CSlmLfDOCHgGqiD495wtJ5azL88q45LKBJqjs8V4RcM/c1Nq8rUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097486; c=relaxed/simple;
	bh=VG/gma+BFp7hRzA92f4i+Yqndd6eyPp9+EeoYIRbU14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNDapcBO+TB77CocGGomt5x1ctyePGQg4zC2yIHTgyivT8oIs8NEDB7CCTl8DcbZ8k6uvxaw28rXQe/BdrZ/qUp0J7FVOBkJiQc8GlMTjbuCb/jDquzNycxEXG3yPL/nEXLqDi8JUi8PqJ6DUJ3XlyohjeXgpF7ZNM8tF/hqYq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+khfm9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+khfm9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671A0C2BCAF;
	Mon, 13 Apr 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097486;
	bh=VG/gma+BFp7hRzA92f4i+Yqndd6eyPp9+EeoYIRbU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+khfm9uJO692lFG7fKmOkjbjKQyk5/ZfXW48hosxwLcFFV7RXCxdPn5gVz2EuuSn
	 VtD/nO/MShr6GJH81cgeX0vGjQEcwLlX1QX2pRo7YFVt8qnUE9QzEvvhq2lWD43xol
	 dkDMrhPqsaZn55zpys63g0oDTzE3s+BWEvxTe2/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 154/570] libceph: Use u32 for non-negative values in ceph_monmap_decode()
Date: Mon, 13 Apr 2026 17:54:45 +0200
Message-ID: <20260413155836.220353163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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


