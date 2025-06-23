Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8DC3FB1B;
	Mon, 23 Jun 2025 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750720465; cv=none; b=H0rQKY3xH2VlghxxYuD4dziINcPJD92zuA+VbeaVvnzvi757i27+AgVeFQ7qNDDI6lRRBAxjj9MzSith04nKLadecIoIUwBe5ebZ3TwlpZFmpnYWYj+dDo53/MhIu6tjT5pnpH6tBzVRMPDgLxxyMZI0lApADHyuobKP0g5ir7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750720465; c=relaxed/simple;
	bh=aerVDBcnJpT8gkHAfn/6JruOABlCLVQZP9CRB2TQtCg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kJ0tIYSCwpk5WoeomHHBwjBp9aSV92VVHpiUBnBMrNhnW0Vs0sD8lZSX3LHiZ27XlakECyUyEWkT+jlo4H2J9djypUnff51R3NQVaQoRJEEHl/4va3RbdC1XtkpbHEtft6bc44VV9Y/ebT43NG2bKwfuqCMtR+wSEJG+R0ggYlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJ/ZlRUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJ/ZlRUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E914C4CEED;
	Mon, 23 Jun 2025 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750720465;
	bh=aerVDBcnJpT8gkHAfn/6JruOABlCLVQZP9CRB2TQtCg=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=gJ/ZlRUGbNtgbDM5ssmVGBHRFXUlo7dR4vV75Izj0sWvhQZxswBAVbDlZZA/b1Aki
	 qZDJBJVXeq33ZtO7pQxXktYbMWjd4OlAC8gYCjKHhugjUgr2uJiAQgRWZPIktIE8tF
	 qz+IXKwOSXwYt59Pa0xknhe+YXzCxhjd4H6J+jJpSPbmMBKgUpo4PReBoLZnW+RcOD
	 CIvqUw+cDASfUDBDqKFkz1nGWFKgNUtLM6EayacmzzycFFFi9m9orNaXOsGmaXCQ5u
	 BG1T3RWdfZc8AjvwiWyMzI60lzKDHGKjqUlLakB3xfqAgJlsj5690zDO4Los9yIGfc
	 j5kUXi0rrA/Pg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2025 01:14:22 +0200
Message-Id: <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
Cc: <patches@lists.linux.dev>, "Alice Ryhl" <aliceryhl@google.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
From: "Benno Lossin" <lossin@kernel.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
In-Reply-To: <20250623130712.686988131@linuxfoundation.org>

On Mon Jun 23, 2025 at 3:07 PM CEST, Greg Kroah-Hartman wrote:
> 6.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Danilo Krummrich <dakr@kernel.org>
>
> [ Upstream commit f744201c6159fc7323c40936fd079525f7063598 ]
>
> In Devres::drop() we first remove the devres action and then drop the
> wrapped device resource.
>
> The design goal is to give the owner of a Devres object control over when
> the device resource is dropped, but limit the overall scope to the
> corresponding device being bound to a driver.
>
> However, there's a race that was introduced with commit 8ff656643d30
> ("rust: devres: remove action in `Devres::drop`"), but also has been
> (partially) present from the initial version on.
>
> In Devres::drop(), the devres action is removed successfully and
> subsequently the destructor of the wrapped device resource runs.
> However, there is no guarantee that the destructor of the wrapped device
> resource completes before the driver core is done unbinding the
> corresponding device.
>
> If in Devres::drop(), the devres action can't be removed, it means that
> the devres callback has been executed already, or is still running
> concurrently. In case of the latter, either Devres::drop() wins revoking
> the Revocable or the devres callback wins revoking the Revocable. If
> Devres::drop() wins, we (again) have no guarantee that the destructor of
> the wrapped device resource completes before the driver core is done
> unbinding the corresponding device.
>
> CPU0					CPU1
> ------------------------------------------------------------------------
> Devres::drop() {			Devres::devres_callback() {
>    self.data.revoke() {			   this.data.revoke() {
>       is_available.swap() =3D=3D true
> 					      is_available.swap =3D=3D false
> 					   }
> 					}
>
> 					// [...]
> 					// device fully unbound
>       drop_in_place() {
>          // release device resource
>       }
>    }
> }
>
> Depending on the specific device resource, this can potentially lead to
> user-after-free bugs.
>
> In order to fix this, implement the following logic.
>
> In the devres callback, we're always good when we get to revoke the
> device resource ourselves, i.e. Revocable::revoke() returns true.
>
> If Revocable::revoke() returns false, it means that Devres::drop(),
> concurrently, already drops the device resource and we have to wait for
> Devres::drop() to signal that it finished dropping the device resource.
>
> Note that if we hit the case where we need to wait for the completion of
> Devres::drop() in the devres callback, it means that we're actually
> racing with a concurrent Devres::drop() call, which already started
> revoking the device resource for us. This is rather unlikely and means
> that the concurrent Devres::drop() already started doing our work and we
> just need to wait for it to complete it for us. Hence, there should not
> be any additional overhead from that.
>
> (Actually, for now it's even better if Devres::drop() does the work for
> us, since it can bypass the synchronize_rcu() call implied by
> Revocable::revoke(), but this goes away anyways once I get to implement
> the split devres callback approach, which allows us to first flip the
> atomics of all registered Devres objects of a certain device, execute a
> single synchronize_rcu() and then drop all revocable objects.)
>
> In Devres::drop() we try to revoke the device resource. If that is *not*
> successful, it means that the devres callback already did and we're good.
>
> Otherwise, we try to remove the devres action, which, if successful,
> means that we're good, since the device resource has just been revoked
> by us *before* we removed the devres action successfully.
>
> If the devres action could not be removed, it means that the devres
> callback must be running concurrently, hence we signal that the device
> resource has been revoked by us, using the completion.
>
> This makes it safe to drop a Devres object from any task and at any point
> of time, which is one of the design goals.
>
> Fixes: 76c01ded724b ("rust: add devres abstraction")
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Closes: https://lore.kernel.org/lkml/aD64YNuqbPPZHAa5@google.com/
> Reviewed-by: Benno Lossin <lossin@kernel.org>
> Link: https://lore.kernel.org/r/20250612121817.1621-4-dakr@kernel.org
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  rust/kernel/devres.rs | 37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)

This is missing the prerequisite patch #1 from

    https://lore.kernel.org/all/20250612121817.1621-1-dakr@kernel.org

---
Cheers,
Benno

