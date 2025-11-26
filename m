Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76CA23EA81;
	Wed, 26 Nov 2025 06:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764139655; cv=none; b=HZIm+IWJWaoC6dNFxVr1+7sblLFCnM4c1nSGmWwWGlhEQoGFz8QuNZiOAW6IU7bBquVeXuQRnsQWy0w8bpKt7k3JVzd07dNsunim5vv9HZgDcSEGQgll6ce7LLlpGV0o01m4/pXrCehhyU2bn0CyoqD+WNV9YjsT2+J9SQpPj0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764139655; c=relaxed/simple;
	bh=qMtBn2TqqvtxevA70+FuFw0T73M4Vy4fDqxzLFN0CZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xjaf/2oMbbPG/4IhET6/kEZtP/sO6iOwQ2CFCxYEh3kwqKt+xEPzVOGZaEU8QYeWazGHPkD5OC/ddQXjYrfoXgLJrkJ38oSlq/gUh/DYGnK/KXd3aseatz808KgXP5GW8fb5piySqpir4obcl0wHyxYpy8snHPiKd+nFmx+Za5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLnMQADe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLnMQADe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A9BC113D0;
	Wed, 26 Nov 2025 06:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764139655;
	bh=qMtBn2TqqvtxevA70+FuFw0T73M4Vy4fDqxzLFN0CZE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OLnMQADeEWWHCE+AVmmv4AkNiqPu+DN60OpX1XXd5haKvWNvy4J0RYDCX+kBfDQ9k
	 kztZmtjL4ijGKhMJjVtZj5DUi4FVaI3pd67t34yGtkJeqg+Xbk45O9f2Scck21p2gJ
	 g/RucAHYUtOfXxIj7ynEVrWi0KHLyBrKbsc4hdxwup1MXPHdTPo/HuB/hhV6ceLrk3
	 lwwrZC6K+faJFs/rJAsESXjyjHHs8SKSMUD05swgXys9yo37dkdlj1eVKIzJm87w9X
	 vj+4zQpwkr50AKg7jjAzw+N5aimIM/+gX/Aa1IzureEsNoytKd0PzwAwL5FIhX8CDf
	 Jy9V+TYBRYZ+A==
Message-ID: <ed7d962e-b350-4986-ae92-14509306ea65@kernel.org>
Date: Wed, 26 Nov 2025 07:47:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 817/849] smb: client: fix potential UAF in
 smb2_close_cached_fid()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jay Shin <jaeshin@redhat.com>,
 "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
 Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <stfrench@microsoft.com>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004556.178148239@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20251111004556.178148239@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11. 11. 25, 1:46, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Henrique Carvalho <henrique.carvalho@suse.com>
> 
> commit 734e99623c5b65bf2c03e35978a0b980ebc3c2f8 upstream.
> 
> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
> 
> Switch to kref_put_lock() so cfid_release() is called with
> cfid_list_lock held, closing that gap.
> 
> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
> Cc: stable@vger.kernel.org
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/smb/client/cached_dir.c |   16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -389,11 +389,11 @@ out:
>   			 * lease. Release one here, and the second below.
>   			 */
>   			cfid->has_lease = false;
> -			kref_put(&cfid->refcount, smb2_close_cached_fid);
> +			close_cached_dir(cfid);
>   		}
>   		spin_unlock(&cfids->cfid_list_lock);
>   
> -		kref_put(&cfid->refcount, smb2_close_cached_fid);
> +		close_cached_dir(cfid);
>   	} else {
>   		*ret_cfid = cfid;
>   		atomic_inc(&tcon->num_remote_opens);
> @@ -434,12 +434,14 @@ int open_cached_dir_by_dentry(struct cif
>   
>   static void
>   smb2_close_cached_fid(struct kref *ref)
> +__releases(&cfid->cfids->cfid_list_lock)
>   {
>   	struct cached_fid *cfid = container_of(ref, struct cached_fid,
>   					       refcount);
>   	int rc;
>   
> -	spin_lock(&cfid->cfids->cfid_list_lock);
> +	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> +

This _backport_ (of a 6.18-rc5 commit) omits to change 
cfids_invalidation_worker() which was removed in 6.18-rc1 by:
7ae6152b7831 smb: client: remove cfids_invalidation_worker

This likely causes:
https://bugzilla.suse.com/show_bug.cgi?id=1254096
BUG: workqueue leaked atomic, lock or RCU

Because cfids_invalidation_worker() still does:
                 kref_put(&cfid->refcount, smb2_close_cached_fid);
instead of now required kref_put_lock() aka:
                 close_cached_dir(cfid);

thanks,
-- 
js
suse labs

