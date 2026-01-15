Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B02C028F;
	Thu, 15 Jan 2026 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496460; cv=none; b=HB1beEXLEpod2SEq6bHBDfNdunUfd4GJzL5n+30Lv7Uwt5NbmBUvRgGdjq95glRPBcaJ1VMmTJ0GshxxjI8uNkHG6XYbqNbhAXHiFcGGFJYa6uEThVPzH8Jpy4SvVDSKUxGIFzSDk1FAeKbytKYO44Z2Wa0jVzqGN4D/fLxTUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496460; c=relaxed/simple;
	bh=x5utBmX91qQ51chHOnTyuh5fJp3uEoMVuNBlhdAX9SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfu5tnm4ulIySUte77ubGzT2nzimYJqZ7uY3+zZeI1+D0bW9c3XHePMI8Z+KgTdkVl+YdiiZang+xnjapx2K1pIshNsx5fvmXspwXT7cXHanbEGnXgcmBbaX6OAO4mzTORM+bgouRFMHFs23Oqr/cDN4onvWIVnJ9xVsPIFX9/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImwtSV6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImwtSV6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6052C116D0;
	Thu, 15 Jan 2026 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496460;
	bh=x5utBmX91qQ51chHOnTyuh5fJp3uEoMVuNBlhdAX9SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImwtSV6k9IlDknflA7/tBldrwPnd6Z/woSovq9tVP9bCh7XJlKuGJhAlSE7n8wYvY
	 9bLygS1teq/HBehkmILtWE0IpPWORv4zFW7EBiAolYtjnt6ENw52XlPuIGFNb5Jh1m
	 Pfe2ASuyOQUL8i0F+Pv+BsWDuUizjL3Tz70HsgJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc7323743ca6dbcc3d3@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 020/119] wifi: avoid kernel-infoleak from struct iw_point
Date: Thu, 15 Jan 2026 17:47:15 +0100
Message-ID: <20260115164152.690370483@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 21cbf883d073abbfe09e3924466aa5e0449e7261 upstream.

struct iw_point has a 32bit hole on 64bit arches.

struct iw_point {
  void __user   *pointer;       /* Pointer to the data  (in user space) */
  __u16         length;         /* number of fields or size in bytes */
  __u16         flags;          /* Optional params */
};

Make sure to zero the structure to avoid disclosing 32bits of kernel data
to user space.

Fixes: 87de87d5e47f ("wext: Dispatch and handle compat ioctls entirely in net/wireless/wext.c")
Reported-by: syzbot+bfc7323743ca6dbcc3d3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/695f83f3.050a0220.1c677c.0392.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260108101927.857582-1-edumazet@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/wext-core.c |    4 ++++
 net/wireless/wext-priv.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -1103,6 +1103,10 @@ static int compat_standard_call(struct n
 		return ioctl_standard_call(dev, iwr, cmd, info, handler);
 
 	iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+
+	/* struct iw_point has a 32bit hole on 64bit arches. */
+	memset(&iwp, 0, sizeof(iwp));
+
 	iwp.pointer = compat_ptr(iwp_compat->pointer);
 	iwp.length = iwp_compat->length;
 	iwp.flags = iwp_compat->flags;
--- a/net/wireless/wext-priv.c
+++ b/net/wireless/wext-priv.c
@@ -228,6 +228,10 @@ int compat_private_call(struct net_devic
 		struct iw_point iwp;
 
 		iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+
+		/* struct iw_point has a 32bit hole on 64bit arches. */
+		memset(&iwp, 0, sizeof(iwp));
+
 		iwp.pointer = compat_ptr(iwp_compat->pointer);
 		iwp.length = iwp_compat->length;
 		iwp.flags = iwp_compat->flags;


