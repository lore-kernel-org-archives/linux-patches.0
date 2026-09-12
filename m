Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1221731F9B4;
	Sat, 12 Sep 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232660; cv=none; b=iR/5dtgySNletgsoIzh66ZfPQMZd1BN+W/4VGIciUhDuH2+7dEj4OYVkN2QeIDLYtYaOjagOdUnba1xXs1FaLTOB/YjW2gFNFUqKCsVSQEcgD8JfyKZp41SZmlU2YQtKTVyzMdKDX77exfWt5Rvo5D7DYoWa7Th9O6E8DTGZa4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232660; c=relaxed/simple;
	bh=qvuAA/xOtEAcNiQD1XlY9OV2kl9oYvNbwi0JkuNlDtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRb+o4lPkdK/zfTnk3j4VrNHwK3UutjK0hNz1tWScU5W1WCbdPhL//oF318r/VivKQMwq2yx//KDQVC7bEp8elktrOzuPLZEheCbUsz4xjx+4G6Fp2Kun8Nv6FnngTS2tL+dTF/fz8n2IebHivOpLeJJhF9aP5LTfed9hEvgj2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCBRKZxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCBRKZxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CEB1F000FF;
	Sat, 12 Sep 2026 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232659;
	bh=vCYPut3RvLxVmE0YE9ftcyRh/W8NihvxuV9sMm3pG0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCBRKZxBNjbUF5rK3CUHtie4Kvtr9WT8xWa7H0imp7vMyqPkq6NZVfb9At2IyPgPi
	 EL7V264h7PBr0lq6qtYXYxMnRz4hR4hQHc9LbxsVOHTFETvJhGVlKQBpr5l/r/EkPw
	 aOyinE6HcDinMb8Gc58jij9kcsef5SvH0Vksb7vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 055/935] ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode
Date: Sat, 12 Sep 2026 08:51:25 +0200
Message-ID: <20260912065528.101232322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit aedc9053d909508a5f56c3f49f885fc030df4730 upstream.

MDSMap export_targets entries are monitor controlled. check_new_map()
uses each entry as a bit number in a fixed stack bitmap, so a rank
outside the protocol namespace can make set_bit() write past the end of
the array.

Reject ranks outside CEPH_MAX_MDS while decoding the map. Do not
validate against possible_max_rank here because maps may legitimately
reference ranks beyond a temporarily reduced max_mds.

Cc: stable@vger.kernel.org
Fixes: d517b3983dd3 ("ceph: reconnect to the export targets on new mdsmaps")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -263,6 +263,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(v
 				goto nomem;
 			for (j = 0; j < num_export_targets; j++) {
 				target = ceph_decode_32(&pexport_targets);
+				if (target >= CEPH_MAX_MDS) {
+					err = -EIO;
+					goto corrupt;
+				}
 				info->export_targets[j] = target;
 			}
 		} else {


