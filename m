Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7B347124F;
	Sat, 12 Sep 2026 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220145; cv=none; b=dFSjhmjYC4maveI/KatzlmP/1FasQ08nJGjwnT5xNV+jtP1C7BDahYT1DHFq9ZUhAv8fBrSicF8MSF5Qkc71pQ5B9j3xVH2MrurUWS6k8IoWlMjXCog53Zh/LDPJTQvd+tA9+se1lGEkE2F0/iovisV0PPFJdll0BqP6MukXSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220145; c=relaxed/simple;
	bh=jJtjz4hTqI1hEoZHs9CZCR+KdgzliFnEqUS4PDL8nuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5BDqvdOjf4nmtf4KGRM/oFiiOJ0uVJkuX76bAHGYf5b+jj60pOtB/lDmkiGHSBYU1vZrkjGFcckRFfZ9qaUXsx9Brt4PvM8LvrHF9aUNSea3BDtMbh6OMoO8/xWqcqljhlPOCK+5yLX0CZz4xE1FCh9Pa+a+ll57BQyJESD0LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu9/XS6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu9/XS6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788901F000FF;
	Sat, 12 Sep 2026 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220143;
	bh=G4tmY73UHzi7WN30Dy/fNJGjOijNWL3Uj8/A4XIMd/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tu9/XS6SfufK/9GorUxSBjBADyYTh5kvCKYXVTQ7nDC8F2SNeEWtPxuHzXfSKs6j/
	 kp6lOYW5wBKjwS3C8l1vL2Kt4lfPui2c9XLyWWt97GzcRsmGXHQXkbSxyhISQmPJci
	 HbOAHOVCCe7TyhOr2nyA08V7DadB3ZrKygDY4wq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 0074/1424] ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode
Date: Sat, 12 Sep 2026 08:41:46 +0200
Message-ID: <20260912065608.964575446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


