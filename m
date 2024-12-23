Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBD51B0F30;
	Mon, 23 Dec 2024 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970169; cv=none; b=b5vDymcMIMJ/6hsFTjKMbg2egnTJlOTE4z6J5W2faPC0O43f62rCr19qGUW/3eCfZD+SNFHbhnDqEYLDQXm0Skrmkw/IKJa6U+jlksk8Ow70Ecdaqn0LRMY7EYFMtd9luzBVhDnv7VJ2FyyIZhELx4hjDVaSGica3rf8g1eVtkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970169; c=relaxed/simple;
	bh=WwZb7qaKFMC7CPJuQbgHax/9zypTR41QAkoTOincHlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+vEGjlHbyZ4ihiKFv+O/mhuoc45QE2JQBoDm098Snpn2JGa+wzDtX5sCtAlE2tEy00V+JK9wv2cffAa58c39aQwr5Z12jOqh7fhSHWynrOACBxSNYuSCL+xmm54Ljso1m7KciWr7Dpp7S/z4HnNz418WAF5Hhz4fU2a+Ki04Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmG/yx8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmG/yx8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07480C4CED3;
	Mon, 23 Dec 2024 16:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970169;
	bh=WwZb7qaKFMC7CPJuQbgHax/9zypTR41QAkoTOincHlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmG/yx8oVUSTLQnIt6iHvanpDWSnUhYdoZKbGjleLs2CxISilbgRHbkWarH5aUY1K
	 SgEosRTOXtBJWTo6FQ44VNfMjVge1DzKCPFT4CwuwtkMXoGag1ssRN74Fv9n0+1a1K
	 Ag0oFYSRxDurDAhswG2BxvVnSMczjVbNRIRuk+ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dario=20Wei=C3=9Fer?= <dario@cure53.de>,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 151/160] ceph: give up on paths longer than PATH_MAX
Date: Mon, 23 Dec 2024 16:59:22 +0100
Message-ID: <20241223155414.648657308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 550f7ca98ee028a606aa75705a7e77b1bd11720f upstream.

If the full path to be built by ceph_mdsc_build_path() happens to be
longer than PATH_MAX, then this function will enter an endless (retry)
loop, effectively blocking the whole task.  Most of the machine
becomes unusable, making this a very simple and effective DoS
vulnerability.

I cannot imagine why this retry was ever implemented, but it seems
rather useless and harmful to me.  Let's remove it and fail with
ENAMETOOLONG instead.

Cc: stable@vger.kernel.org
Reported-by: Dario Weißer <dario@cure53.de>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2808,12 +2808,11 @@ retry:
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn_client(cl, "did not end path lookup where expected (pos = %d)\n",
-			       pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;


