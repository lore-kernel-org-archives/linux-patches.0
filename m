Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901A169AD2;
	Tue, 16 Jun 2026 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635210; cv=none; b=hg6XYHNaJQSZS5L3W1EhnQOVUdOrM810NIM133L1D/kZuOP6AYqtX49ZFpcaPuHVBNl+4fu1dZS2asnsXbY0hoXcoHwJX2329YqQ9X+98nucqLMWJbgoWHYlcXlp0zW6COOEDK5GOVDcU4aRbp2o0C69Q0oLHllgk8XtvovU2d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635210; c=relaxed/simple;
	bh=vGKW/48VMo+c0uCAd5cnteswBXjfVq7dz9WIbvIkryA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYmtdhk2KnRfCA2Lo5HmzR1HWTSGfoqEKu2i/3dzr6hmy5IsJjRv3hGGr4cecwMpBV/98o6jDcOWt9QpxWOsgXM8irO5GZcFnkXgSc2q3poXNPxN4dgMD0ZHdx7lEFrm+gsOEQO/Sz4XJC5Oay0pbx6hMlKDkL6piyYFw2/mlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9IxaQqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9IxaQqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71B31F000E9;
	Tue, 16 Jun 2026 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635209;
	bh=Ff3w0f5ccwjRhc0sthpF+S2xo/Hdg+LSWXWt2ouuu14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9IxaQqZa2LTwxT+XkkI23Mvp1WR2r1fOUywlRX9Q5fi9m7HGQp0bUjVMWUNN7YRb
	 AmWOLb5sqoMdKom2YztG9rL5dHmv+/1Y9SLIjhpIPz6TFYoqW5lM96M6wkNbzbEMUR
	 4fhB5EkMeqBa53H/SI/678EDc09MztgpwdGpg9pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Liem <liem16213@gmail.com>
Subject: [PATCH 5.15 401/411] selinux: enable genfscon labeling for securityfs
Date: Tue, 16 Jun 2026 20:30:39 +0530
Message-ID: <20260616145122.494211749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

commit 8a764ef1bd43fb2bb4ff3290746e5c820a3a9716 upstream.

Add support for genfscon per-file labeling of securityfs files.
This allows for separate labels and thereby access control for
different files. For example a genfscon statement

    genfscon securityfs /integrity/ima/policy \
	system_u:object_r:ima_policy_t:s0

will set a private label to the IMA policy file and thus allow to
control the ability to set the IMA policy. Setting labels directly
with setxattr(2), e.g. by chcon(1) or setfiles(8), is still not
supported.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
[PM: line width fixes in the commit description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Liem <liem16213@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -741,7 +741,8 @@ static int selinux_set_mnt_opts(struct s
 	    !strcmp(sb->s_type->name, "tracefs") ||
 	    !strcmp(sb->s_type->name, "binder") ||
 	    !strcmp(sb->s_type->name, "bpf") ||
-	    !strcmp(sb->s_type->name, "pstore"))
+	    !strcmp(sb->s_type->name, "pstore") ||
+	    !strcmp(sb->s_type->name, "securityfs"))
 		sbsec->flags |= SE_SBGENFS;
 
 	if (!strcmp(sb->s_type->name, "sysfs") ||


