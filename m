Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC68381AF9;
	Fri,  4 Sep 2026 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500726; cv=none; b=PEh1WTqYL2Ovx/QzQrM9c7SfOBsuTeT4Amr/3Hc4c5h3dZ3UGXEfRcHiLjzuuiyEjEzfd1k6UaF+1tIdBG7eJ5bKzQ45F0RI8qAGyn2a1FSCwLkrE7roo4qHx/l+Tsu2LrJdT/cNg5W3czBei8Oub32g72dN/L2zfET4DSop6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500726; c=relaxed/simple;
	bh=5VnrDp9gjuoQxuQUXldoGhbOMb3WLPOjPFRH2Zx9jZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uF0n/TClCe9VOO6xM+2XrgI+RA6dOtvAIQ0rl9OYMek+v09Q6+6ZI8RhN0A/VtzfKkq8EwWo3FdhbgibFwvPMrn8NB9rupEtriCqVas39/FJhNEDOUUms4pf8c1JXvdl1D1O7amoKcfAw4fvjrA6DtC8zz+DezigiMRVo/DcWzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG5S4wM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG5S4wM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E6C1F00A3D;
	Fri,  4 Sep 2026 05:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500725;
	bh=PrqLRtnMhuXzHw8D6yIK87kGfr4fly+m4yvqVo6Ke5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG5S4wM7MKPwQ5rFlqKTbnuKKATkPUqsI042h4ethkjJN5mIi6OLU2ad66IPWqqq+
	 +BbqXQ8WN23m7iM0r5jOuwgyn/5XVpPNo7MWXhmp8Kr+pb0D/pPUUn5WtmbbddINvo
	 R3y9/+n3BCv+nGBj+yyq1kTyO4pPIda/A9HdKVkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 156/552] ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode
Date: Fri,  4 Sep 2026 06:55:13 +0200
Message-ID: <20260904045752.399005528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


