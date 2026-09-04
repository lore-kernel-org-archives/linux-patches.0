Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9BD3A9854;
	Fri,  4 Sep 2026 05:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498923; cv=none; b=UTtFdzElA9cUr/Lyieph0C7FZekJt6SrOFFgS3Wu77hoJPz0LW0ig162TcswZamj/s5XMY4uXWoJEU35cH1PsszVntCL98Z9/A34BuhC5Lj19hugfzCWH7g2yz2LdN4vUI6a9tPGkQS8Tblu7v72lRVGzdj22uYstswxu3IjPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498923; c=relaxed/simple;
	bh=WwLzxNqaWRrPe6mrujsIpFX+CpPwM6PoQ/1WaJw5fNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UX8gc05OHrkieLVwb27GIxpd+p/32fsA8o74AGlXJeoV2DIAi47pVnbgsNZOk8XNP7vNrX2zvrXEe0vz2L57A6i7ZeIZGmn7GsDJ7/tsc+UKqlnoRdmGVhfUfWenC9MzcYMY7wkYCieIh5lmbimHZ34CvEZB4ou3jJgn2N8Yt3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhxKBrMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhxKBrMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0549D1F00A3D;
	Fri,  4 Sep 2026 05:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498922;
	bh=jnS+/jAVrxg884+MnL6D7XsyMG+c0B7a6gkrdJhUF4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhxKBrMG9s0cdKraz3lghQH2XdaK7q9tK5UxVPVTWkE1KUecHWvhPLqWQ8EXQmML8
	 h9UcZlwhNmNHQFF8btNBFAQ5ZO9CMy0MkdbUpdCNaPXCJVO/tRDLe9aKT2/1rQTWe7
	 Sz0Vp6SG8fXB1Gpet0KR2eBOhe67tYNdmxc5ul10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 218/713] ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode
Date: Fri,  4 Sep 2026 06:53:06 +0200
Message-ID: <20260904045808.703297270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -264,6 +264,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s
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


