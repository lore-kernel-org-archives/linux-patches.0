Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772C941B8C6;
	Sat, 12 Sep 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227068; cv=none; b=hsbTSVhDwBsScX1/5WxOoPOkbHH/CaBd7HkZEv8PgOllH9RXaxmBj6q1pvZUxo6x1pT24DazROrg27rqxqTC6Zw8OIZki9xRqfnxd3jrRdizgEHa6Kq5RbLMhmCbJbzH9Oxm8VV6IFVJgiTMeVSfpBIU1OZgG+kiycIC8Dl2u8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227068; c=relaxed/simple;
	bh=L82CyIJcKl/pU6nrnYu68ywxEliFakM9nLYjLq34JJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mt5Ok1Jso8mmkigQ5oI2vj+I5LMdTZl9zHjcM3H95+6WCIjV8e9XV/IK5eRpBjvUuc311Y0t+IdlFkZlZvk9JOj7/HicW7JxC5QoexeO+j+dyAXXiDqoMHk/Mbx77Z/r3AKRNIp7tcm7ZpcHmK/ZhkkyppIidmPaZQwSczDNxmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBvFMT//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBvFMT//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BF61F000FF;
	Sat, 12 Sep 2026 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227067;
	bh=Dcb8OmqlhX3RFpreHnDE9lOoLRPcafSrnPSLxxWRKE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBvFMT//zIsHdBIpy7KWeWIY9tB71aTGdrXAmudgMjkg9B08zz8k+XHgo9E6b+8zp
	 jGmWe1kkpB4Bq4+BouP8ce+sfXSHNIh+Qxek8q8Rdx/kftW3E5yJAWZF5HrUrNJOy6
	 48m3h/AsHdhOctVOVvdmMK7Gz/ueeyytAVNbpWXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 0062/1191] ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode
Date: Sat, 12 Sep 2026 08:46:30 +0200
Message-ID: <20260912065549.549535345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


