Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8301237F738;
	Thu, 20 Aug 2026 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239500; cv=none; b=Oj3kbHaxzeKAqqbbhrtsxpU/GY8ZBa7IVYAx8kjBznpQeGuiVNi0EqzU5Oj/5+ay+q1HIq12U+Ir+UfBUU7GBQzVD6P4n+MNYjTIrUPBol+uckVjSjjGV+Jxxz6UT5ffRiqPPIjo6Hw0bTwKuFxg94F96oyGQPEGxaRsruZSbcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239500; c=relaxed/simple;
	bh=s6Ab2xdcFoDoyU56XHnovTFr02HCIFcfxYjDuvbpOk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTiCvAKdjUicGQ0eWU0oqeAhJ7C4M8NUg+ubqocP/BANfNXi1+hMi6sSWaXv7BLOd3QyVpMng/IuVPxy+BnzxQQzvPjKMGUkeI9PR4ZLEj1rZKf42UJq4/Uo5j97x64c95f9Zh/gIX05U8eNd52vnPWptIl84qBL+B4rA//7JBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wth2eR9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wth2eR9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C831F000E9;
	Thu, 20 Aug 2026 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239499;
	bh=zFN0WK5bGtfWVEkot6qSg+DYde2lgaYwJN+CO7gMrZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wth2eR9QX1btKxIJbrGIqSVUIvwmKKWqfBDhNzvJuEZpnvmuhqb/IDGzGI3n0RrDI
	 tbGMZo2vHfAmXirSTdpsbO2rkpLcZKbCraN9kahnokcf2qcgWEbdWdy7NUs01qNnJq
	 NATsNQGB8EsOdaclG8RmYHychQkPx8CoEBUSbDNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 071/220] s390/vfio_ccw: Limit the number of channel program segments
Date: Thu, 20 Aug 2026 16:54:21 +0200
Message-ID: <20260820145225.624787667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 5405c90d6a47b3014e74ee0618a162449abbbc93 upstream.

The processing of channel programs, and the CCWs within them, is done
recursively. As such, there is an arbitrary (but not architectural)
limit to the number of CCWs that can exist in a single channel program.

The vfio-ccw logic breaks these channel programs into segments whenever
it encounters a Transfer-In-Channel (TIC) CCW, and the combined number
of segments count towards the global limit. Impose an equivalent limit
to the number of segments until such logic can be made non-recursive.

Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |    6 ++++++
 drivers/s390/cio/vfio_ccw_cp.h |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -332,6 +332,7 @@ static struct ccwchain *ccwchain_alloc(s
 		goto out_err;
 
 	list_add_tail(&chain->next, &cp->ccwchain_list);
+	cp->ccwchain_count++;
 
 	return chain;
 
@@ -441,6 +442,10 @@ static int ccwchain_handle_ccw(dma32_t c
 	if (len < 0)
 		return len;
 
+	/* Limit number of chains in a single channel program */
+	if (cp->ccwchain_count >= CCWCHAIN_COUNT_MAX)
+		return -EINVAL;
+
 	/* Need alloc a new chain for this one. */
 	chain = ccwchain_alloc(cp, len);
 	if (!chain)
@@ -745,6 +750,7 @@ int cp_init(struct channel_program *cp,
 			vdev->dev,
 			"Prefetching channel program even though prefetch not specified in ORB");
 
+	cp->ccwchain_count = 0;
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
 
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -23,11 +23,18 @@
  */
 #define CCWCHAIN_LEN_MAX	256
 
+/*
+ * Maximum number of chains
+ */
+#define CCWCHAIN_COUNT_MAX	16
+
 /**
  * struct channel_program - manage information for channel program
  * @ccwchain_list: list head of ccwchains
  * @orb: orb for the currently processed ssch request
  * @initialized: whether this instance is actually initialized
+ * @guest_cp: copy of guest channel program
+ * @ccwchain_count: number of channel program segments (linked by TIC)
  *
  * @ccwchain_list is the head of a ccwchain list, that contents the
  * translated result of the guest channel program that pointed out by
@@ -38,6 +45,7 @@ struct channel_program {
 	union orb orb;
 	bool initialized;
 	struct ccw1 *guest_cp;
+	unsigned int ccwchain_count;
 };
 
 int cp_init(struct channel_program *cp, union orb *orb);


