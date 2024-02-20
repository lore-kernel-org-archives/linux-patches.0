Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1846D2DF9F;
	Tue, 20 Feb 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465284; cv=none; b=DzaLYt4MP921UgGe6d+fspZ4AXRHZjonzWmiBog/WemAxXRnqNrFP8SdOekc6lZQUCIJYnnLIODvUnbK8wnrfkpQUWD3Mx8vzJ5mR3994it4feASzKjyaUe8LwhjqN3v5SaWYVVlN11fUedYYkRtc6QTj/cW7JUDDn0TCkbE+oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465284; c=relaxed/simple;
	bh=M8CM6+UnA5LtyeR2iiccl1C7YDAMucRaUV+x2qgGtt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiyXHx0o8v4Kb+kE/QMPfInPrJtaIVmMWW7iNrTNhrVV4xebWKUNYMd6H4bGxtrDXG0fNYNIJ6mRgr/KPVuMcbjvUZJRriAYqjBg4S2HJJsbWUVWbuMgLRgq99qoYRg3Fk31KDeZlT1LBhbIkFPWuCIPg0Co2dY35hMhbd96KWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FisTbTks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FisTbTks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EE3C433F1;
	Tue, 20 Feb 2024 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465284;
	bh=M8CM6+UnA5LtyeR2iiccl1C7YDAMucRaUV+x2qgGtt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FisTbTksuZazqLqhrBBXA2Ixz0a9BS0mm/sawxVRZjbwU6ikXGLjo/Ra7NpcuIwdU
	 TcJoAubHG5DeHQDJsvEh5PM87+JefsTDbtdimp+Wx/MdcvPOdGybPIEnnfRhCp1/RJ
	 p/ZRAVpvzfHLc5u7k4HKM8XO+fmADn0via5e6QeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishabh Dave <ridave@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.7 287/309] ceph: prevent use-after-free in encode_cap_msg()
Date: Tue, 20 Feb 2024 21:57:26 +0100
Message-ID: <20240220205642.094166865@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rishabh Dave <ridave@redhat.com>

commit cda4672da1c26835dcbd7aec2bfed954eda9b5ef upstream.

In fs/ceph/caps.c, in encode_cap_msg(), "use after free" error was
caught by KASAN at this line - 'ceph_buffer_get(arg->xattr_buf);'. This
implies before the refcount could be increment here, it was freed.

In same file, in "handle_cap_grant()" refcount is decremented by this
line - 'ceph_buffer_put(ci->i_xattrs.blob);'. It appears that a race
occurred and resource was freed by the latter line before the former
line could increment it.

encode_cap_msg() is called by __send_cap() and __send_cap() is called by
ceph_check_caps() after calling __prep_cap(). __prep_cap() is where
arg->xattr_buf is assigned to ci->i_xattrs.blob. This is the spot where
the refcount must be increased to prevent "use after free" error.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/59259
Signed-off-by: Rishabh Dave <ridave@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1452,7 +1452,7 @@ static void __prep_cap(struct cap_msg_ar
 	if (flushing & CEPH_CAP_XATTR_EXCL) {
 		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
 		arg->xattr_version = ci->i_xattrs.version;
-		arg->xattr_buf = ci->i_xattrs.blob;
+		arg->xattr_buf = ceph_buffer_get(ci->i_xattrs.blob);
 	} else {
 		arg->xattr_buf = NULL;
 		arg->old_xattr_buf = NULL;
@@ -1553,6 +1553,7 @@ static void __send_cap(struct cap_msg_ar
 	encode_cap_msg(msg, arg);
 	ceph_con_send(&arg->session->s_con, msg);
 	ceph_buffer_put(arg->old_xattr_buf);
+	ceph_buffer_put(arg->xattr_buf);
 	if (arg->wake)
 		wake_up_all(&ci->i_cap_wq);
 }


